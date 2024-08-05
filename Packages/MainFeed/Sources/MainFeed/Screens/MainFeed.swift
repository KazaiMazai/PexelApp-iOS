//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import SwiftUI
import DesignSystem
import SwiftUIExtensions

struct MainFeedListView: View {
    let fetch: (Int?) async throws -> ([Picture], Int)
    
    var body: some View {
        PaginatedList(
            content: content,
            footer: footer,
            errorView: errorView,
            placeholder: placeholder,
            empty: empty,
            fetch: fetch)
    }
    
    private func content(_ pictures: [Picture]) -> some View {
        ForEach(pictures) {
            Text($0.photographer)
        }
    }
    
    private func footer(_ state: NextPageState) -> some View {
        switch state {
        case .none:
            Text("Loading")
        case .loading:
            Text("Loading")
        case .error:
            Text("Retry")
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        Text("Error: \(error.localizedDescription)")
    }
    
    private func placeholder() -> some View {
        Text("Loading")
    }
    
    private func empty() -> some View {
        Color.clear
    }
}


public struct MainFeed: View {
    @Environment(PexelAPIService.self) var pexelAPIService: PexelAPIService
    
    public init() {
        
    }
    
    public var body: some View {
        MainFeedListView(fetch: pexelAPIService.fetch)
    }
}
