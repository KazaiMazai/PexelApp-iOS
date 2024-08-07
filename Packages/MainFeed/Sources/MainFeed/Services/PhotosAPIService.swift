//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07/08/2024.
//

import Foundation
import PexelAPI

public final class PhotosAPIService {
    private let client: PexelAPI.Client
    private let urlSession: URLSession

    public init(client: PexelAPI.Client,
                urlSession: URLSession) {

        self.client = client
        self.urlSession = urlSession
    }
}

extension PhotosAPIService {
    func fetch(page: Int, limit: Int = 10) async throws -> (items: [Picture], nextPage: Int) {
        let request = try client.curatedPhotos(
            page: .init(page: page, perPage: limit)
        )
        switch request.type {
        case .data(let handler):
            let (data, response) = try await urlSession.data(for: request.urlRequest)
            let result = try handler(data, response)
            let items = result.photos.map { $0.appModel() }
            return (items, page + 1)
        }
    }
}

fileprivate extension PexelAPI.Client.Responses.Photo {
    func appModel() -> Picture {
        Picture(
            id: "\(id)",
            photographer: photographer ?? "",
            width: width ?? .zero,
            height: height ?? .zero,
            original: src.original,
            large2x: src.large2x,
            large: src.large,
            medium: src.medium,
            small: src.small,
            tiny: src.tiny
        )
    }
}
