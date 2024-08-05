//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation

extension Client.Responses {
    public struct SuccessResponse: Codable {
        let success: Bool
    }

    struct ErrorResponse: Codable {
        let message: String
    }
}

extension Client.Responses {
    public struct Empty: Codable { }
}
