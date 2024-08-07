//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import Foundation
import PexelAPI

@MainActor
@Observable
public final class PhotosService {
    private var storage: PhotosStorageService
    private var apiService: PhotosAPIService
    
    public init(storage: PhotosStorageService,
                apiService: PhotosAPIService) {
        
        self.storage = storage
        self.apiService = apiService
    }
     
    func find(_ id: Picture.ID) -> Picture? {
        storage.find(id)
    }
     
    func fetch(page: Int?) async throws -> ([Picture.ID], Int?) {
        let result = try await apiService.fetch(page: page ?? 0)
        storage.save(result.items)
        return (result.items.map { $0.id }, result.nextPage)
    }
}
