//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07/08/2024.
//

import SwiftUI

public extension Animation {
    static var theme: ThemeAnimations.Type {
        ThemeAnimations.self
    }
}

public enum ThemeAnimations { }

public extension ThemeAnimations {
    static let interactiveSpring: Animation = {
        .interactiveSpring(
            response: 0.6,
            dampingFraction: 0.7,
            blendDuration: 0.7)
    }()
}

