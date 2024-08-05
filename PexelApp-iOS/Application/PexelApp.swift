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
    static let urlSession = URLSession.shared
    
    static let client = Client(
        apiKey: EnvironmentVars.pexelAPIKey,
        baseURL: URL(string: "https://api.pexels.com")!,
        version: .v1
    )
    
    static let prod: DI = {
        DI(pexelAPIClient: client,
           photosAPIService: PhotosAPIService(client: client,
                                              urlSession: urlSession)
        )
    }()
}
