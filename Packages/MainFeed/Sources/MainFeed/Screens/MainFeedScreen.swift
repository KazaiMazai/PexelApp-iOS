//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import SwiftUI
import DesignSystem
import SwiftUIExtensions

@MainActor
public struct MainFeedScreen: View {
    @Environment(PhotosService.self) var photosService: PhotosService

    public init() {

    }

    public var body: some View {
        MainFeedListView(
            fetch: photosService.fetch,
            find: photosService.find
        )
    }
}

@MainActor
struct MainFeedListView: View {
    @Namespace var detailViewNamespace
    @State var selectedPicture: Picture?

    let fetch: (_ page: Int?) async throws -> ([Picture.ID], Int?)
    let find: (Picture.ID) -> Picture?

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
        .modal($selectedPicture,
               animation: .theme.interactiveSpring) { pictureId, progress in
            pictureDetailView(pictureId, presentationProgress: progress)
        }
    }
}

private extension MainFeedListView {
    func content(_ pictures: [Picture.ID]) -> some View {
        ForEach(pictures, id: \.self) { pictureId in
            pictureListView(
                pictureId
            )
            .listRowModifier()
        }
    }

    @ViewBuilder
    func pictureListView(_ id: Picture.ID) -> some View {
        switch find(id) {
        case .some(let picture):
            Button(action: {
                select(picture)
            }, label: {
                ImageWithText(
                    picture: picture
                )
                .cardStyle()
                .matchedGeometryEffect(id: id, in: detailViewNamespace, isSource: selectedPicture == nil)
            })
            .buttonStyle(ScaleButtonStyle())
        case .none:
            EmptyView()
        }
    }

    @ViewBuilder
    func pictureDetailView(_ picture: Picture, presentationProgress: CGFloat) -> some View {
        ImageWithText(
            picture: picture
        )
        .cardStyle(with: presentationProgress)
        .matchedGeometryEffect(id: picture.id, in: detailViewNamespace, isSource: selectedPicture != nil)
    }

    func select(_ picture: Picture) {
        withAnimation(.theme.interactiveSpring) {
            selectedPicture = picture
        }
    }

    @ViewBuilder
    func footer(_ state: NextPageState) -> some View {
        switch state {
        case .done:
            EmptyView()
        case .hasMore:
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

    func errorView(_ error: Error, refresh: PaginatedList.Refresh) -> some View {
        ListErrorView(message: "Couldn't load the feed")
    }

    func placeholder() -> some View {
        ListPlaceholder(title: "Loading Photos")
    }

    func empty(refresh: @escaping PaginatedList.Refresh) -> some View {
        EmptyListView(
            refresh: refresh,
            message: "No Photos",
            buttonTitle: "Tap to Reload"
        )
    }
}

extension ImageWithText {
    init(picture: Picture) {
        self.init(
            image: picture.mediumAvailable.map {
                .url($0)
            } ?? .placeholder(text: "No image"),
            title: picture.photographer
        )
    }
}

fileprivate extension View {
    func listRowModifier() -> some View {
        self.listRowInsets(
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
