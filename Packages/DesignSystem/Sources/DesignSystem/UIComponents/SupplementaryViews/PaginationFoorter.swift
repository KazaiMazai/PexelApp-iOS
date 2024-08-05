//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import SwiftUI


public struct PaginationFooter: View {
    public enum State {
        case initial
        case loading
        case error(message: String)
    }
    
    public var state: State
    
    public init(state: PaginationFooter.State) {
        self.state = state
    }
    
    public var body: some View {
        switch state {
        case .initial, .loading:
            ProgressView()
        case .error(let message):
            Text(message)
                .font(.theme.body)
                .foregroundStyle(.theme.accent)
        }
    }
}
