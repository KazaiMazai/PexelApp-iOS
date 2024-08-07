//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07/08/2024.
//

import SwiftUI

public struct ListErrorView: View {
    private let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        Text("\(Image(systemName: "xmark.circle.fill")) \(message)")
    }
}
