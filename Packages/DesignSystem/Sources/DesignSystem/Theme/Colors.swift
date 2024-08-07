//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import SwiftUI

public extension Color {
    static var theme: ThemeColors.Type {
        ThemeColors.self
    }
}

public enum ThemeColors { }

public extension ThemeColors {
    static var accent: Color {
        .accentColor
    }
    
    static var title: Color {
        .black
    }
    
    static var subtitle: Color {
        .gray
    }
    
    static var placeholder: Color {
        .gray
    }
 
    static var background: Color {
        .gray
    }
    
    static var cardBackground: Color {
        .white
    }
    
    static var shadow: Color {
        .black.opacity(0.1)
    }
    
    static var failedImageBackground: Color {
        .gray
    }
}
 
public enum ThemeShapeStyleColors { }

public extension ShapeStyle where Self == Color {
   static var theme: ThemeShapeStyleColors.Type {
       ThemeShapeStyleColors.self
   }
}

public extension ThemeShapeStyleColors {
    static var accent: some ShapeStyle {
        Color.theme.accent
    }
    
    static var title: some ShapeStyle {
        Color.theme.title
    }
    
    static var subtitle: some ShapeStyle {
        Color.theme.subtitle
    }
    
    static var placeholder: Color {
        Color.theme.placeholder
    }
 
    static var background: some ShapeStyle {
        Color.theme.background
    }
    
    static var cardBackground: some ShapeStyle {
        Color.theme.cardBackground
    }
    
    static var shadow: some ShapeStyle {
        Color.theme.shadow
    }
}
