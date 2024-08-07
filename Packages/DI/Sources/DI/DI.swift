//
//  File.swift
//
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import SwiftUI
import PexelAPI
import MainFeed

// swiftlint:disable:next type_name
public struct DI {
    public let pexelAPIClient: Client
    public let photosAPIService: PhotosService
    public let asyncImageURLSession: URLSession

    public init(pexelAPIClient: Client,
                photosAPIService: PhotosService,
                asyncImageURLSession: URLSession) {

        self.pexelAPIClient = pexelAPIClient
        self.photosAPIService = photosAPIService
        self.asyncImageURLSession = asyncImageURLSession
    }
}

public extension View {
    func environment(diContainer: DI) -> some View {
        self.environment(diContainer.photosAPIService)
            .asyncImageURLSession(diContainer.asyncImageURLSession)
    }
}
