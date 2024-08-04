// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUIExtensions

public class Client {
    private(set) var apiKey: String?
   
    init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}
 
