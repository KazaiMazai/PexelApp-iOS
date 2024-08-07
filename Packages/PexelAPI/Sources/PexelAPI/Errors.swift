//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation

extension Client {
    public enum Errors: Error {
        case unauthorrized

        case serverError(message: String)
        case unknownResponseFormat
        case unknownServerError
        case emptyResponse
        case invalidURL(URL)
    }
}

extension Client.Errors: LocalizedError {
        public var errorDescription: String? {
            switch self {
            case .unauthorrized:
                return "Unauthorized"
            case .serverError(let message):
                return message
            case .unknownResponseFormat:
                return "Unknown Response Format"
            case .unknownServerError:
                return "Unknown Server Error"
            case .emptyResponse:
                return "Empty response"
            case .invalidURL(let urlString):
                return "Invalid URL: \(urlString)"
            }
        }
}
