//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07/08/2024.
//

import SwiftUI

public struct ListPlaceholder: View {
    private let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        HStack(spacing: .theme.padddings.large) {
            ProgressView()
            
            Text(title)
                .font(.theme.body)
                .foregroundStyle(.theme.title)
        }
    }
    
}
