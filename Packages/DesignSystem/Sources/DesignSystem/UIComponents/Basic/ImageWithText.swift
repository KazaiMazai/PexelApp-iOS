//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import SwiftUI
import SwiftUIExtensions

@MainActor
public struct ImageWithText: View {
    private let image: ImageSource
    private let text: String
    
    public enum ImageSource {
        case url(URL)
        case placeholder(text: String)
        case image(UIImage)
    }
    
    public init(image: ImageWithText.ImageSource,
                title: String) {
        
        self.image = image
        self.text = title
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            switch image {
            case .url(let url):
                urlImageView(url)
            case .image(let image):
                imageView(image)
            case .placeholder(let text):
                placeholder(text)
            }
            
            Text(text)
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
                image.resizable()
                     .aspectRatio(contentMode: .fit)
            case .failure:
                Color.theme.failedImageBackground
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
            ImageWithText.previews[0]
            
            ImageWithText.previews[1]
            
            ImageWithText.previews[2]
        }
        .padding()
    }
}

public extension ImageWithText {
    static let previews: [ImageWithText] = {
        [
            ImageWithText(
                image: .url(
                    URL(string:"https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMTc3M3wwfDF8c2VhcmNofDF8fGdpdGh1YnxlbnwwfHx8fDE3MTU5MDg1MjN8MA&ixlib=rb-4.0.3&q=80&w=1140")!),
                title: "Hello world"
            ),
            
            ImageWithText(
                image: .placeholder(text: "No image"),
                title: "Hello world"
            ),
            
            ImageWithText(
                image: .image(UIImage(systemName: "heart.fill")!),
                title: "Hello world"
            )
        ]
    }()
}
