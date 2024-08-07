//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07/08/2024.
//

import Foundation

public final class PhotosStorageService {
    private var storage: [Picture.ID: Picture] = [:]

    public init() {

    }

    func find(_ id: Picture.ID) -> Picture? {
        storage[id]
    }

    func save(_ items: [Picture]) {
        items.forEach { storage[$0.id] = $0 }
    }
}
