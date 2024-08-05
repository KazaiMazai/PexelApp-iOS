//
//  File.swift
//
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import SwiftUI

extension PaginatedListView {
    enum NextPageState {
        case none
        case loading
        case error(Error)
    }
    
    @MainActor
    @Observable final class ViewModel<T> {
        
        enum State {
            case initial
            case loading
            case display([T], nextCursor: String?, nextPage: NextPageState)
            case empty
            case error(error: Error)
        }
        
        var state = State.initial
        let fetch: (String?) async throws -> (items: [T], cursor: String?)
        
        init(fetch: @escaping (String?) async throws -> (items: [T], cursor: String?)) {
            self.fetch = fetch
        }
        
        func initialFetch() async {
            do {
                state = .loading
                let result = try await fetch(nil)
                
                state = result.items.isEmpty ? 
                    .empty
                    : .display(result.items, nextCursor: result.cursor, nextPage: .none)
            } catch {
                state = .error(error: error)
            }
        }
        
        func fetchNextPage() async throws {
            guard case .display(var items, let nextCursor, _) = state else {
                return
            }
            state = .display(items, nextCursor: nextCursor, nextPage: .loading)
            do {
                let result = try await fetch(nextCursor)
                items.append(contentsOf: result.items)
                state = .display(items, nextCursor: result.cursor, nextPage: .none)
            } catch {
                state = .display(items, nextCursor: nextCursor, nextPage: .error(error))
            }
        }
    }
}

struct PaginatedListView<Data,
                         Content: View,
                         Footer: View,
                         ErrorMessage: View,
                         Empty: View,
                         Placeholder: View>: View {
    
    let content: ([Data]) -> Content
    let footer: (NextPageState) -> Footer
    let errorView: (Error) -> Content
    let placeholder: () -> Placeholder
    let empty: () -> Empty
    
    let viewModel: ViewModel<Data>
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            placeholder()
        case .empty:
            empty()
        case .initial:
            placeholder()
        case .display(let items, _, let nextPage):
            makeContent(items, nextPage: nextPage)
        case .error(error: let error):
            errorView(error)
        }
    }
     
    
    private func makeContent(_ items: [Data],
                             nextPage: NextPageState) -> some View {
        List {
            content(items)
            switch nextPage {
            case .loading:
                footer(nextPage)
            case .error(let error):
                footer(nextPage)
            case .none:
                footer(nextPage).onAppear {
                    Task { try await viewModel.fetchNextPage() }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
    }
}
