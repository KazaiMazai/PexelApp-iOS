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
    @Namespace var detailViewNamespace
    @State var selectedPicture: Picture?
    
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
        .setRefreshable(true)
        .modal($selectedPicture) { picture, opacity in
            ImageWithText(
                viewModel: ImageWithText.ViewModel(picture: picture)
            )
            .cornerRadius((1.0 - opacity) * .theme.corners.large)
            .shadow(.theme.largeDropShadow)
            .matchedGeometryEffect(id: picture, in: detailViewNamespace, isSource: selectedPicture != nil)
        }
    }
}

private extension MainFeedListView {
    func content(_ pictures: [Picture]) -> some View {
        ForEach(pictures.indices, id: \.self) { index in
            Button(action: {
                select(pictures[index])
            }, label: {
                ImageWithTextCard(
                    viewModel: ImageWithText.ViewModel(
                        picture: pictures[index]
                    )
                )
                .matchedGeometryEffect(id: pictures[index], in: detailViewNamespace, isSource: selectedPicture == nil)
            })
            .buttonStyle(ScaleButtonStyle())
            .listRowInsets(
                EdgeInsets(
                    top: .zero,
                    leading: .theme.padddings.large,
                    bottom: .theme.padddings.xxxLarge,
                    trailing: .theme.padddings.large
                )
            )
            .listRowSeparator(.hidden)
        }
    }
    
    func select(_ picture: Picture) {
        withAnimation(.interactiveSpring(
            response: 0.6,
            dampingFraction: 0.7,
            blendDuration: 0.7)) {
                
                selectedPicture = picture
            }
    }
    
    func pictureCardView(_ picture: Picture) -> some View {
        ImageWithTextCard(
            viewModel: ImageWithText.ViewModel(
                picture: picture
            )
        )
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

extension ImageWithText.ViewModel {
    init(picture: Picture) {
        self.init(
            image: picture.mediumAvailable
                .map { .url($0) } ?? .placeholder(text: "No image"),
            title: picture.photographer
        )
    }
}
