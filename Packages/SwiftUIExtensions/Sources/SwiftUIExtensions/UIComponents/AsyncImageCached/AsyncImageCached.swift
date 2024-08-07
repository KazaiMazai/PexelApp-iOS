//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06/08/2024.
//

import SwiftUI

@MainActor
public struct AsyncImageCached<Content: View>: View {
    @Environment(\.asyncImageURLSession) var urlSession
    
    @State private var fetchResult: (url: URL, image: Result<(UIImage), Error>)?
    @ViewBuilder private let content: (AsyncImagePhase) -> Content
    
    private let url: URL
    
    public init(url: URL, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.content = content
    }
    
    public var body: some View {
        if let fetchResult, fetchResult.url == url {
            contentFor(fetchResult.image)
        } else {
            placeholder()
        }
    }
}

public extension AsyncImageCached {
    enum Errors: Error {
        case imageDataIsMalformed
        case couldNotRetrieveImage
    }
}

private extension AsyncImageCached {
    func placeholder() -> some View {
        content(.empty).task {
            await downloadImage()
        }
    }
    
    func contentFor(_ result: Result<UIImage, Error>) -> some View {
        switch result {
        case .success(let image):
            content(.success(Image(uiImage: image)))
        case .failure(let error):
            content(.failure(error))
        }
    }
   
    func downloadImage() async {
        do {
            let cache = urlSession.configuration.urlCache
            if let cache, let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
               let image = UIImage(data: cachedResponse.data) {
                self.fetchResult = (url, .success(image))
                return
            }
            
            let (data, _) = try await urlSession.data(from: url)
            guard let image = UIImage(data: data) else {
                self.fetchResult = (url, .failure(Errors.imageDataIsMalformed))
                return
            }
            
            self.fetchResult = (url, .success(image))
        } catch {
            self.fetchResult = (url, .failure(Errors.couldNotRetrieveImage))
        }
    }
}
