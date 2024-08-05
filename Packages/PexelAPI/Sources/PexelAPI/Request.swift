//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation

public extension Client {
     enum Requests { }
}

public enum RequestType<Result: Decodable> {
    case data(handler: (Data, URLResponse) throws -> Result)
}

public struct Request<Result: Decodable> {
    public let type: RequestType<Result>
    public let urlRequest: URLRequest
    
    public init(urlRequest: URLRequest,
                type: RequestType<Result>) {
        self.urlRequest = urlRequest
        self.type = type
    }
}

extension Client {
    func asDictionary<T: Encodable>(_ parameters: T) -> [String: Any]? {
        guard let data = try? encoder.encode(parameters) else {
            return nil
        }
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return jsonObject.flatMap { $0 as? [String: Any] }
    }
    
    func asURLQueryParameters<T: Encodable>(_ parameters: T) -> [URLQueryItem] {
        asDictionary(parameters)?
            .map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) } ?? []
    }
}
