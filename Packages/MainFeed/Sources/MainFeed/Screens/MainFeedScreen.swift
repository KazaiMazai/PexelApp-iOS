//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import SwiftUI
import DesignSystem
import SwiftUIExtensions

public struct MainFeedScreen: View {
    @Environment(PhotosAPIService.self) var photosAPIService: PhotosAPIService
    
    public init() {
        
    }
    
    public var body: some View {
        MainFeedListView(fetch: photosAPIService.fetch)
    }
}

struct MainFeedListView: View {
    let fetch: (_ page: Int?) async throws -> ([Picture], Int?)
    
    init(fetch: @escaping (_ page: Int?) async throws -> ([Picture], Int?)) {
        self.fetch = fetch
    }
    
    var body: some View {
        PaginatedList(
            content: content,
            footer: footer,
            errorView: errorView,
            placeholder: placeholder,
            empty: empty,
            fetch: fetch
        )
    }
}

private extension MainFeedListView {
    func content(_ pictures: [Picture]) -> some View {
        ForEach(pictures.indices, id: \.self) { index in
            ImageWithTitleCard(
                viewModel: ImageWithTitleCard.ViewModel(
                    picture: pictures[index], 
                    selection: {}
                )
            )
            .listRowInsets(
                EdgeInsets(
                    top: .zero,
                    leading: .theme.padddings.large,
                    bottom: .theme.padddings.xxxLarge,
                    trailing: .theme.padddings.large
                )
            )
            .listRowSeparator(.hidden)
            .zIndex(Double(pictures.count - index))
        }
    }
    
    @ViewBuilder
    func footer(_ state: NextPageState) -> some View {
        switch state {
        case .none:
            PaginationFooter(state: .initial).id(UUID())
                .frame(maxWidth: .infinity, alignment: .center)
        case .loading:
            PaginationFooter(state: .loading).id(UUID())
                .frame(maxWidth: .infinity, alignment: .center)
        case .error:
            PaginationFooter(state: .error(message: "Retry")).id(UUID())
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    func errorView(_ error: Error) -> some View {
        Text("\(Image(systemName: "xmark.circle.fill")) Couldn't load the feed")
    }
    
    func placeholder() -> some View {
        HStack(spacing: .theme.padddings.large) {
            ProgressView()
            Text("Loading")
        }
    }
    
    func empty() -> some View {
        Color.clear
    }
}

extension ImageWithTitleCard.ViewModel {
    init(picture: Picture, selection: @escaping () -> Void) {
        self.init(
            image: picture.mediumAvailable
                .map { .url($0) } ?? .placeholder(text: "No image"),
            title: picture.photographer,
            selection: selection
        )
    }
}

