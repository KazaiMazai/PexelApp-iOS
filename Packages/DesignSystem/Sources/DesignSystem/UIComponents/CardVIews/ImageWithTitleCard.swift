//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import SwiftUI

public extension ImageWithTitleCard {
    struct ViewModel {
        
        public enum Image {
            case url(URL)
            case placeholder(text: String)
            case image(UIImage)
        }
        
        public init(image: ImageWithTitleCard.ViewModel.Image,
                    title: String,
                    selection: @escaping () -> Void) {
            
            self.image = image
            self.title = title
            self.selection = selection
        }
        
        let image: Image
        let title: String
        let selection: () -> Void
    }
}
 
public struct ImageWithTitleCard: View {
    let viewModel: ViewModel
    
    public init(viewModel: ImageWithTitleCard.ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Button(action: viewModel.selection) {
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
        }
        .buttonStyle(PlainButtonStyle())
        .background(.theme.cardBackground)
        .cornerRadius(.theme.corners.large)
        .shadow(.theme.largeDropShadow)
    }
    
    private func urlImageView(_ url: URL) -> some View {
        AsyncImage(url: url, content: { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
            
        }, placeholder: {
            ProgressView()
                .frame(height: 300)
        })
    }
    
    private func imageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
         
    }
    
    private func placeholder(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(.theme.placeholder)
            .font(.theme.title2)
            .padding(.vertical, .theme.padddings.medium)
    }
}
 
#Preview {
    ScrollView {
        VStack {
            ImageWithTitleCard(
                viewModel: .previews[0]
            )
            
            ImageWithTitleCard(
                viewModel: .previews[1]
            )
            
            ImageWithTitleCard(
                viewModel: .previews[2]
            )
        }
        .padding()
    }
}

public extension ImageWithTitleCard.ViewModel {
    static let previews: [ImageWithTitleCard.ViewModel] = {
        [
            ImageWithTitleCard.ViewModel(
                image: .url(
                    URL(string:"https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMTc3M3wwfDF8c2VhcmNofDF8fGdpdGh1YnxlbnwwfHx8fDE3MTU5MDg1MjN8MA&ixlib=rb-4.0.3&q=80&w=1140")!),
                title: "Hello world",
                selection: {}
            ),
            
            ImageWithTitleCard.ViewModel(
                image: .placeholder(text: "No image"),
                title: "Hello world",
                selection: {}
            ),
            
            ImageWithTitleCard.ViewModel(
                image: .image(UIImage(systemName: "heart.fill")!),
                title: "Hello world",
                selection: {}
            )
        ]
    }()
}
