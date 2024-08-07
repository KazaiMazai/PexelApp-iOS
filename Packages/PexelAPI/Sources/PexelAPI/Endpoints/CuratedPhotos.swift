//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation

public extension Client {
    func curatedPhotos(page: Client.Requests.ResourceCollectionPage) throws -> Request<Responses.PhotosCollection> {
        try dataRequest(urlRequest: get(
                baseURL,
                to: "/\(version.path)/curated",
                with: asURLQueryParameters(page)
            )
        )
    }
}
