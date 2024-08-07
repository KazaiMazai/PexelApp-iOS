import XCTest
@testable import SwiftUIExtensions
@testable import Collections

final class SwiftUIExtensionsTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}

final class PaginatedListStateTests: XCTestCase {

    func testNextPageStateInit() {
        // Test when cursor is nil
        var state = NextPageState(cursor: nil as Int?)
        XCTAssertTrue(state.isDone)

        // Test when cursor is not nil
        state = NextPageState(cursor: 1)
        XCTAssertTrue(state.isHavingMore)
    }

    func testPaginatedListStateNextCursor() {
        // Test nextCursor when state is .content
        let state: PaginatedListState<Int, Int> = .content(OrderedSet([1, 2, 3]), nextCursor: 1, nextPage: .hasMore)
        XCTAssertEqual(state.nextCursor, 1)

        // Test nextCursor when state is not .content
        let emptyState: PaginatedListState<Int, Int> = .empty
        XCTAssertNil(emptyState.nextCursor)
    }

    func testPaginatedListStateNeedsInitFetch() {
        // Test needsInitFetch when state is .initial
        let initialState: PaginatedListState<Int, Int> = .initial
        XCTAssertTrue(initialState.needsInitFetch)

        // Test needsInitFetch when state is not .initial
        let loadingState: PaginatedListState<Int, Int> = .loading
        XCTAssertFalse(loadingState.needsInitFetch)
    }

    func testPaginatedListStateIsLoading() {
        // Test isLoading when state is .loading
        let loadingState: PaginatedListState<Int, Int> = .loading
        XCTAssertTrue(loadingState.isLoading)

        // Test isLoading when state is not .loading
        let initialState: PaginatedListState<Int, Int> = .initial
        XCTAssertFalse(initialState.isLoading)
    }

    func testPaginatedListStateIsEmpty() {
        // Test isEmpty when state is .empty
        let emptyState: PaginatedListState<Int, Int> = .empty
        XCTAssertTrue(emptyState.isEmpty)

        // Test isEmpty when state is not .empty
        let initialState: PaginatedListState<Int, Int> = .initial
        XCTAssertFalse(initialState.isEmpty)
    }

    func testPaginatedListStateSetItems() {
        // Test setting items when the list is empty
        var state: PaginatedListState<Int, Int> = .initial
        state.setItems([], cursor: nil)
        XCTAssertTrue(state.isEmpty)

        // Test setting items when the list has content
        state.setItems([1, 2, 3], cursor: 1)
        XCTAssertEqual(state.nextCursor, 1)
        if case let .content(items, nextCursor, nextPage) = state {
            XCTAssertEqual(items, OrderedSet([1, 2, 3]))
            XCTAssertEqual(nextCursor, 1)
            XCTAssertTrue(nextPage.isHavingMore)
        } else {
            XCTFail("Expected state to be .content")
        }
    }

    func testPaginatedListStateAppendItems() {
        // Test appending items to a non-content state
        var state: PaginatedListState<Int, Int> = .initial
        state.appendItems([1, 2, 3], cursor: 1)
        XCTAssertEqual(state.nextCursor, 1)
        if case let .content(items, nextCursor, nextPage) = state {
            XCTAssertEqual(items, OrderedSet([1, 2, 3]))
            XCTAssertEqual(nextCursor, 1)
            XCTAssertTrue(nextPage.isHavingMore)
        } else {
            XCTFail("Expected state to be .content")
        }

        // Test appending items to a content state
        state.appendItems([4, 5], cursor: 2)
        XCTAssertEqual(state.nextCursor, 2)
        if case let .content(items, nextCursor, nextPage) = state {
            XCTAssertEqual(items, OrderedSet([1, 2, 3, 4, 5]))
            XCTAssertEqual(nextCursor, 2)
            XCTAssertTrue(nextPage.isHavingMore)
        } else {
            XCTFail("Expected state to be .content")
        }
    }

    func testPaginatedListStateSetError() {
        // Test setting an error state
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        var state: PaginatedListState<Int, Int> = .initial
        state.setError(error)
        if case let .error(err) = state {
            XCTAssertEqual(err.localizedDescription, error.localizedDescription)
        } else {
            XCTFail("Expected state to be .error")
        }
    }

    func testPaginatedListStateSetNextPageLoading() {
        // Test setting next page loading
        var state: PaginatedListState<Int, Int> = .content(OrderedSet([1, 2, 3]), nextCursor: 1, nextPage: .hasMore)
        state.setNextPageLoading()
        if case let .content(_, _, nextPage) = state {
            XCTAssertTrue(nextPage.isLoading)
        } else {
            XCTFail("Expected state to be .content")
        }
    }

    func testPaginatedListStateSetNextPageLoadingError() {
        // Test setting next page loading error
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        var state: PaginatedListState<Int, Int> = .content(OrderedSet([1, 2, 3]), nextCursor: 1, nextPage: .hasMore)
        state.setNextPageLoadingError(error)
        if case let .content(_, _, nextPage) = state {
            if case let .error(err) = nextPage {
                XCTAssertEqual(err.localizedDescription, error.localizedDescription)
            } else {
                XCTFail("Expected nextPage state to be .error")
            }
        } else {
            XCTFail("Expected state to be .content")
        }
    }
}
