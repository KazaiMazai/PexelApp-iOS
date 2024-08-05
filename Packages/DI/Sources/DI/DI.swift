// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import PexelAPI
import MainFeed

public struct DI {
    public let pexelAPIClient: PexelAPI.APIClient
    public let pexelAPIService: MainFeed.PexelAPIService
    
    public init(pexelAPIClient: APIClient) {
        self.pexelAPIClient = pexelAPIClient
    }
    
}
 


