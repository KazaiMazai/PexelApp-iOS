//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation

public enum NextPageState {
    case none
    case loading
    case error(Error)
}

enum PaginatedListState<T, Cursor> {
    case initial
    case loading
    case content([T], nextCursor: Cursor?, nextPage: NextPageState)
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
    
    var hasMore: Bool {
        nextCursor != nil
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
       self = items.isEmpty ? .empty
        : .content(items, nextCursor: cursor, nextPage: .none)
    }
    
    mutating func appendItems(_ items: [T], cursor: Cursor?) {
        guard case .content(var currentItems, _, _) = self else {
            setItems(items, cursor: cursor)
            return
        }
        
        currentItems.append(contentsOf: items)
        self = .content(currentItems, nextCursor: cursor, nextPage: .none)
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
