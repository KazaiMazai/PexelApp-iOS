//
//  PexelApp_iOSApp.swift
//  PexelApp-iOS
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import SwiftUI
import DI
import MainFeed
import PexelAPI

@main
struct PexelApp: App {
    let diContainer: DI = .prod
    
    var body: some Scene {
        WindowGroup {
            MainFeedScreen()
                .environment(diContainer: diContainer)
        }
    }
}

extension DI {
    static let asyncImageURLSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = URLCache(
            memoryCapacity: 500 * 1024 * 1024, //(500 MB),
            diskCapacity: 500 * 1024 * 1024, //(500 MB),
            diskPath: "AsyncImageURLSessionCache"
        )
        return URLSession(configuration: config)
    }()
    
    static let urlSession: URLSession = {
        let session = URLSession.shared
        session.configuration.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024, //(50 MB),
            diskCapacity: 50 * 1024 * 1024, //(50 MB),
            diskPath: "URLSessionCache"
        )
        return session
    }()
    
    static let client = Client(
        apiKey: EnvironmentVars.pexelAPIKey,
        baseURL: URL(string: "https://api.pexels.com")!,
        version: .v1
    )
    
    static let prod: DI = {
        DI(pexelAPIClient: client,
           photosAPIService: PhotosService(
            client: client,
            urlSession: urlSession
           ),
           asyncImageURLSession: asyncImageURLSession
        )
    }()
}
