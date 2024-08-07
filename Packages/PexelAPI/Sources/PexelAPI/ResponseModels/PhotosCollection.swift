//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation

extension Client.Responses {
    public struct PhotosCollection: Codable {
        public let photos: [Photo]
        public let page: Int
        public let perPage: Int
        public let totalResults: Int
    }
}
