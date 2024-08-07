//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07/08/2024.
//

import SwiftUI

public struct EmptyListView: View {
    private let refresh: () async -> Void
    private let message: String
    private let buttonTitle: String

    public init(refresh: @escaping () async -> Void, message: String, buttonTitle: String) {
        self.refresh = refresh
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    public var body: some View {
        VStack(spacing: .theme.padddings.xLarge) {
            Text(message)
                .font(.theme.title3)
                .foregroundStyle(.theme.title)
            
            Button(
                action: { Task { await refresh() } },
                label: {
                    Text(buttonTitle)
                        .font(.theme.body)
                        .foregroundStyle(.theme.accent)
                }
                
            )
        }
    }
}
