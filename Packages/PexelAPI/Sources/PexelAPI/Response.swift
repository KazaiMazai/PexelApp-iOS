//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import Foundation

public extension Client {
    enum Responses { }
}

extension Client {
    public enum Response<Result: Decodable> {
        case success(Result)
        case cancelled
        case unauthorized(Error)
        case failed(Error)
    }
}
