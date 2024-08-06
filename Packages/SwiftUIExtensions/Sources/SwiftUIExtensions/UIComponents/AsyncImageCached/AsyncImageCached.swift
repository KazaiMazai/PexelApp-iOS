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
    
    private let url: URL
    
    @State private var result: Result<UIImage, Error>?
    @ViewBuilder let content: (AsyncImagePhase) -> Content
    
    public init(url: URL, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.content = content
    }
    
    public var body: some View {
        if let result {
            contentFor(result)
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

public extension EnvironmentValues {
    var asyncImageURLSession: URLSession {
        get { self[AsyncImageURLSession.self] }
        set { self[AsyncImageURLSession.self] = newValue }
    }
}

public extension View {
    func asyncImageURLSession(_ urlSession: URLSession) -> some View {
        environment(\.asyncImageURLSession, urlSession)
    }
}

private struct AsyncImageURLSession: EnvironmentKey {
    static let defaultValue = URLSession.shared
}

private extension AsyncImageCached {
    func placeholder() -> some View {
        content(.empty).task(id: url) {
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
                self.result = .success(image)
                return
            }
            
            let (data, _) = try await urlSession.data(from: url)
            guard let image = UIImage(data: data) else {
                self.result = .failure(Errors.imageDataIsMalformed)
                return
            }
            
            self.result = .success(image)
        } catch {
            self.result = .failure(Errors.couldNotRetrieveImage)
        }
    }
}
