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
    public let photosService: PhotosService
    public let asyncImageURLSession: URLSession

    public init(pexelAPIClient: Client,
                photosService: PhotosService,
                asyncImageURLSession: URLSession) {

        self.pexelAPIClient = pexelAPIClient
        self.photosService = photosService
        self.asyncImageURLSession = asyncImageURLSession
    }
}

public extension View {
    func environment(diContainer: DI) -> some View {
        self.environment(diContainer.photosService)
            .asyncImageURLSession(diContainer.asyncImageURLSession)
    }
}
