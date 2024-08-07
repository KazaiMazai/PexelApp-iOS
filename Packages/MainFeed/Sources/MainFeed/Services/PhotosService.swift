//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import Foundation
import PexelAPI

@Observable
public final class PhotosService {
    private var storage: [Picture.ID: Picture] = [:]

    private let client: PexelAPI.Client
    private let urlSession: URLSession

    public init(client: PexelAPI.Client,
                urlSession: URLSession) {

        self.client = client
        self.urlSession = urlSession
    }

    func find(_ id: Picture.ID) -> Picture? {
        storage[id]
    }

    func fetch(page: Int?) async throws -> ([Picture.ID], Int?) {
        let page = page ?? 0
        let limit = 10
        let request = try client.curatedPhotos(
            page: .init(page: page, perPage: limit)
        )
        switch request.type {
        case .data(let handler):
            let (data, response) = try await urlSession.data(for: request.urlRequest)
            let result = try handler(data, response)
            let items = result.photos.map { $0.appModel() }
            items.forEach { storage[$0.id] = $0 }
            return (items.map { $0.id }, page + 1)
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
