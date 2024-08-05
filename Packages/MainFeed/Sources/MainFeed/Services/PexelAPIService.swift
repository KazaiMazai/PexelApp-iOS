//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import Foundation

@MainActor
@Observable
public final class PexelAPIService {
    
    func fetch(page: Int, limit: Int) async throws -> [Picture] {
        []
    }
    
    func fetch(page: Int?) async throws -> ([Picture], Int) {
        let page = page ?? 0
        let pictures = try await fetch(page: page, limit: 10)
        return (pictures, page + 1)
    }
}
