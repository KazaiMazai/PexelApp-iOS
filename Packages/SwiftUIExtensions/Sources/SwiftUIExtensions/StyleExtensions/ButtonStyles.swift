//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06/08/2024.
//

import SwiftUI

public struct ScaleButtonStyle: ButtonStyle {
    let scale: CGFloat
    
    public init(scale: CGFloat = 0.9) {
        self.scale = scale
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
