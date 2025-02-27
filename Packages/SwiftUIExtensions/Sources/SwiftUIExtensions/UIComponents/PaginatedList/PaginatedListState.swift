//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation
import Collections

public enum NextPageState {
    case done
    case hasMore
    case loading
    case error(Error)

    init<Cursor>(cursor: Cursor?) {
        self = cursor == nil ? .done : .hasMore
    }
}

extension NextPageState {
    var isDone: Bool {
        if case .done = self {
            return true
        }
        return false
    }

    var isHavingMore: Bool {
        if case .hasMore = self {
            return true
        }
        return false
    }

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
}

enum PaginatedListState<T: Hashable, Cursor> {
    case initial
    case loading
    case content(OrderedSet<T>, nextCursor: Cursor?, nextPage: NextPageState)
    case empty
    case error(error: Error)
}

extension PaginatedListState {
    var nextCursor: Cursor? {
        guard case let .content(_, nextCursor, _) = self else {
            return nil
        }

        return nextCursor
    }

    var needsInitFetch: Bool {
        guard case .initial = self else {
            return false
        }

        return true
    }

    var isLoading: Bool {
        guard case .loading = self else {
            return false
        }

        return true
    }

    var isEmpty: Bool {
        guard case .empty = self else {
            return false
        }

        return true
    }
}

extension PaginatedListState {
    mutating func setItems(_ items: [T], cursor: Cursor?) {
        let nextPage = NextPageState(cursor: cursor)
        self = items.isEmpty ? .empty : .content(OrderedSet(items), nextCursor: cursor, nextPage: nextPage)
    }

    mutating func appendItems(_ items: [T], cursor: Cursor?) {
        guard case .content(var currentItems, _, _) = self else {
            setItems(items, cursor: cursor)
            return
        }

        currentItems.append(contentsOf: items)
        let nextPage = NextPageState(cursor: cursor)
        self = .content(currentItems, nextCursor: cursor, nextPage: nextPage)
    }

    mutating func setError(_ error: Error) {
        self = .error(error: error)
    }

    mutating func setNextPageLoading() {
        guard case let .content(items, nextCursor, _) = self else {
            return
        }

        self = .content(items, nextCursor: nextCursor, nextPage: .loading)
    }

    mutating func setNextPageLoadingError(_ error: Error) {
        guard case let .content(items, nextCursor, _) = self else {
            return
        }

        self = .content(items, nextCursor: nextCursor, nextPage: .error(error))
    }
}
