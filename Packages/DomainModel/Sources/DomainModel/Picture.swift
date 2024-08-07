//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation

public struct Picture: Identifiable, Hashable {
    public typealias ID = String
    
    public let id: ID
    public let photographer: String
    
    public let width: Double
    public let height: Double
    
    public let original: URL?
    public let large2x: URL?
    public let large: URL?
    public let medium: URL?
    public let small: URL?
    public let tiny: URL?
    
    public init(id: String, 
                photographer: String,
                width: Double,
                height: Double,
                original: URL? = nil,
                large2x: URL? = nil,
                large: URL? = nil,
                medium: URL? = nil,
                small: URL? = nil,
                tiny: URL? = nil) {
        
        self.id = id
        self.photographer = photographer
        self.width = width
        self.height = height
        self.original = original
        self.large2x = large2x
        self.large = large
        self.medium = medium
        self.small = small
        self.tiny = tiny
    }
    
    public var largestAvailable: URL? {
        [large2x, large, medium, small, tiny]
            .compactMap { $0 }
            .first
        
    }
    
    public var mediumAvailable: URL? {
        [medium, small, tiny]
            .compactMap { $0 }
            .first
        
    }
}

