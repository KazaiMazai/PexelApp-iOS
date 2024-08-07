//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation

public extension Client.Requests {
    struct ResourceCollectionPage: Codable {
        let page: Int
        let perPage: Int

        public init(page: Int, perPage: Int) {
            self.page = page
            self.perPage = perPage
        }
    }
}
