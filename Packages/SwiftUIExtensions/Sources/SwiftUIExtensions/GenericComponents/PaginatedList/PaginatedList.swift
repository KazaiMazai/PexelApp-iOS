//
//  File.swift
//
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import SwiftUI

@MainActor
public struct PaginatedList<Data: Hashable,
                            Cursor,
                            Content: View,
                            Footer: View,
                            ErrorMessage: View,
                            Empty: View,
                            Placeholder: View>: View {
    
    private let content: ([Data]) -> Content
    private let footer: (NextPageState) -> Footer
    
    private(set) var errorView: (Error) -> ErrorMessage
    private(set) var placeholder: () -> Placeholder
    private(set) var empty: () -> Empty
    
    private(set) var fetch: (Cursor?) async throws -> (items: [Data], cursor: Cursor?)
   
    @State private var state: PaginatedListState<Data, Cursor> = .initial
    
    public var body: some View {
        switch state {
        case .loading:
            placeholder()
        case .empty:
            empty()
        case .initial:
            placeholder().onAppear {
                state = .loading
                Task { await initialFetch() }
            }
        case .content(let items, _, let nextPage):
            makeContent(items.elements, nextPage: nextPage)
        case .error(error: let error):
            errorView(error)
        }
    }
    
    public init(content: @escaping ([Data]) -> Content,
                footer: @escaping (NextPageState) -> Footer,
                errorView: @escaping (any Error) -> ErrorMessage,
                placeholder: @escaping () -> Placeholder,
                empty: @escaping () -> Empty,
                fetch: @escaping (Cursor?) async throws -> (items: [Data], cursor: Cursor?)) {
        
        self.content = content
        self.footer = footer
        self.errorView = errorView
        self.placeholder = placeholder
        self.empty = empty
        self.fetch = fetch
    }
}

private extension PaginatedList {
    
    func makeContent(_ items: [Data],
                     nextPage: NextPageState) -> some View {
      
        List {
            content(items)
            
            switch nextPage {
            case .loading:
                footer(nextPage)
            case .error:
                Button(
                    action: {
                        state.setNextPageLoading()
                        Task { await fetchNextPage() }
                    },
                    label: {
                        footer(nextPage)
                    }
                )
            case .none:
                footer(nextPage).onAppear {
                    state.setNextPageLoading()
                    Task { await fetchNextPage() }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.plain)
    }
}

private extension PaginatedList {
    
    func initialFetch() async {
        do {
            let result = try await fetch(nil)
            state.setItems(result.items, cursor: result.cursor)
        } catch {
            state.setError(error)
        }
    }
    
    func fetchNextPage() async {
        do {
            guard let nextCursor = state.nextCursor else {
                state.appendItems([], cursor: nil)
                return
            }
            
            let result = try await fetch(nextCursor)
            state.appendItems(result.items, cursor: result.cursor)
        } catch {
            state.setNextPageLoadingError(error)
        }
    }
}


