//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import SwiftUI
import SwiftUIExtensions

public extension ImageWithText {
    struct ViewModel {
        public enum ImageViewModel {
            case url(URL)
            case placeholder(text: String)
            case image(UIImage)
        }
        
        public init(image: ImageWithText.ViewModel.ImageViewModel,
                    title: String) {
            
            self.image = image
            self.title = title
        }
        
        let image: ImageViewModel
        let title: String
    }
}
 
@MainActor
public struct ImageWithText: View {
    private let viewModel: ViewModel
    
    public init(viewModel: ImageWithText.ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        VStack(spacing: 0) {
            switch viewModel.image {
            case .url(let url):
                urlImageView(url)
            case .image(let image):
                imageView(image)
            case .placeholder(let text):
                placeholder(text)
            }
            
            Text(viewModel.title)
                .foregroundStyle(.theme.title)
                .font(.theme.title2)
                .lineLimit(0)
                .padding(.vertical, .theme.padddings.xLarge)
                .padding(.horizontal, .theme.padddings.medium)
                .frame(maxWidth: .infinity, alignment: .center)
            
        }
        .background(.theme.cardBackground)
    }
}

private extension ImageWithText {
    func urlImageView(_ url: URL) -> some View {
        AsyncImageCached(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(height: 300)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                Text("\(Image(systemName: "xmark.circle.fill")) Couldn't load the image")
                    .frame(height: 300)
            @unknown default:
                ProgressView()
                    .frame(height: 300)
            }
        }
    }
    
    func imageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
         
    }
    
    func placeholder(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(.theme.placeholder)
            .font(.theme.title2)
            .padding(.vertical, .theme.padddings.medium)
    }
}
 
#Preview {
    ScrollView {
        VStack {
            ImageWithText(
                viewModel: .previews[0]
            )
            
            ImageWithText(
                viewModel: .previews[1]
            )
            
            ImageWithText(
                viewModel: .previews[2]
            )
        }
        .padding()
    }
}

public extension ImageWithText.ViewModel {
    static let previews: [ImageWithText.ViewModel] = {
        [
            ImageWithText.ViewModel(
                image: .url(
                    URL(string:"https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMTc3M3wwfDF8c2VhcmNofDF8fGdpdGh1YnxlbnwwfHx8fDE3MTU5MDg1MjN8MA&ixlib=rb-4.0.3&q=80&w=1140")!),
                title: "Hello world"
            ),
            
            ImageWithText.ViewModel(
                image: .placeholder(text: "No image"),
                title: "Hello world"
            ),
            
            ImageWithText.ViewModel(
                image: .image(UIImage(systemName: "heart.fill")!),
                title: "Hello world"
            )
        ]
    }()
}
