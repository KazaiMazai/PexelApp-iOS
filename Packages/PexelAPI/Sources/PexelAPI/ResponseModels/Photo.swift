//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06/08/2024.
//

import Foundation

extension Client.Responses {
    public struct Photo: Codable {
        public let id: Int
        public let photographer: String?

        public let width: Double?
        public let height: Double?
        public let src: Sources
    }
}

extension Client.Responses.Photo {
    public struct Sources: Codable {
        public let original: URL?
        public let large2x: URL?
        public let large: URL?
        public let medium: URL?
        public let small: URL?
        public let portrait: URL?
        public let landscape: URL?
        public let tiny: URL?
    }
}
