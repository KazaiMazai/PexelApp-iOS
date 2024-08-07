//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07/08/2024.
//

import SwiftUI

public extension View {
    func cardStyle() -> some View {
        self.cornered(.theme.corners.large)
            .shadow(.theme.largeDropShadow)
    }

    func cardStyle(with cornerRatio: CGFloat) -> some View {
        self.cornered((1.0 - cornerRatio) * .theme.corners.large)
            .shadow(.theme.largeDropShadow)
    }
}
