//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import SwiftUI

// swiftlint:disable identifier_name
public struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}
// swiftlint:enable identifier_name

public extension View {
    func shadow(_ shadow: Shadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}

public enum ThemeShadows { }

public extension Shadow {
    static var theme: ThemeShadows.Type {
        ThemeShadows.self
    }
}

public extension ThemeShadows {
    static var largeDropShadow: Shadow {
        Shadow.init(color: .theme.shadow, radius: 50, x: 0, y: 10)
    }

    static var smallDropShadow: Shadow {
        Shadow.init(color: .theme.shadow, radius: 20, x: 0, y: 10)
    }
}
