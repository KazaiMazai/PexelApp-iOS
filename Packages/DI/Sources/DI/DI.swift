//
//  File.swift
//
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import SwiftUI
import PexelAPI
import MainFeed

public struct DI {
    public let pexelAPIClient: Client
    public let photosAPIService: PhotosAPIService
    
    public init(pexelAPIClient: Client,
                photosAPIService: PhotosAPIService) {
        self.pexelAPIClient = pexelAPIClient
        self.photosAPIService = photosAPIService
    }
}

public extension View {
    func environment(diContainer: DI) -> some View {
        environment(diContainer.photosAPIService)
    }
}
 


