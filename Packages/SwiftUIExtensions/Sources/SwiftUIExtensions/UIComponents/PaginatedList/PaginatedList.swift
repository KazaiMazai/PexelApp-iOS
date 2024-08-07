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
                            Failure: View,
                            Empty: View,
                            Placeholder: View>: View {

    public typealias Refresh = () async -> Void

    private let content: ([Data]) -> Content
    private let footer: (NextPageState) -> Footer
    private var refreshable: Bool = false

    private(set) var failure: (Error, _ refresh: @escaping Refresh) -> Failure
    private(set) var placeholder: () -> Placeholder
    private(set) var empty: (_ refresh: @escaping Refresh) -> Empty

    private(set) var fetch: (Cursor?) async throws -> (items: [Data], cursor: Cursor?)

    @State private var state: PaginatedListState<Data, Cursor> = .initial

    public var body: some View {
        switch state {
        case .loading:
            placeholder()
        case .empty:
            empty(initialFetch)
        case .initial:
            placeholder().onAppear {
                Task { await initialFetch() }
            }
        case .content(let items, _, let nextPage):
            List {
                content(items.elements)
                paginatingFooter(nextPage) {
                    Task { await fetchNextPage() }
                }
            }
            .refreshable(refreshable, perform: { await refreshFetch() })
            .scrollDismissesKeyboard(.immediately)
            .listStyle(.plain)
        case .error(error: let error):
            failure(error, initialFetch)
        }
    }

    public init(content: @escaping ([Data]) -> Content,
                footer: @escaping (NextPageState) -> Footer,
                errorView: @escaping (any Error, _ refresh: @escaping Refresh) -> Failure,
                placeholder: @escaping () -> Placeholder,
                empty: @escaping (_ refresh: @escaping Refresh) -> Empty,
                fetch: @escaping (Cursor?) async throws -> (items: [Data], cursor: Cursor?)) {

        self.content = content
        self.footer = footer
        self.failure = errorView
        self.placeholder = placeholder
        self.empty = empty
        self.fetch = fetch
    }
}

public extension PaginatedList {
    func setRefreshable(_ isRefreshable: Bool) -> Self {
        var copy = self
        copy.refreshable = isRefreshable
        return copy
    }
}

private extension PaginatedList {
    @ViewBuilder
    func paginatingFooter(_ nextPageState: NextPageState,
                          loadMore: @escaping () -> Void) -> some View {

        switch nextPageState {
        case .done:
            EmptyView()
        case .loading:
            footer(nextPageState)
        case .error:
            Button(action: loadMore) {
                footer(nextPageState)
            }
        case .hasMore:
            footer(nextPageState)
                .onAppear(perform: loadMore)
        }
    }
}

private extension List {
    @ViewBuilder
    func refreshable(_ isRefreshable: Bool, perform action: @escaping @Sendable () async -> Void) -> some View {
        if isRefreshable {
            refreshable(action: action)
        } else {
            self
        }
    }
}

private extension PaginatedList {
    func refreshFetch() async {
        do {
            let result = try await fetch(nil)
            state.setItems(result.items, cursor: result.cursor)
        } catch {
            state.setError(error)
        }
    }

    func initialFetch() async {
        state = .loading
        do {
            let result = try await fetch(nil)
            state.setItems(result.items, cursor: result.cursor)
        } catch {
            state.setError(error)
        }
    }

    func fetchNextPage() async {
        state.setNextPageLoading()
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
