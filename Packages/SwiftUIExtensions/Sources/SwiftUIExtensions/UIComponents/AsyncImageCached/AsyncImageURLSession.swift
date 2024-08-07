//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07/08/2024.
//

import SwiftUI

public extension EnvironmentValues {
    var asyncImageURLSession: URLSession {
        get { self[AsyncImageURLSession.self] }
        set { self[AsyncImageURLSession.self] = newValue }
    }
}

public extension View {
    func asyncImageURLSession(_ urlSession: URLSession) -> some View {
        environment(\.asyncImageURLSession, urlSession)
    }
}

private struct AsyncImageURLSession: EnvironmentKey {
    static let defaultValue = URLSession.shared
}
