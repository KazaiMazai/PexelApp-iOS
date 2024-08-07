//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import SwiftUI

public extension Font {
    static var theme: ThemeFonts.Type {
        ThemeFonts.self
    }
}

public enum ThemeFonts { }

public extension ThemeFonts {
    static var title: Font {
        Font.title
    }
    static var title2: Font {
        Font.title2
    }

    static var title3: Font {
        Font.title3
    }

    static var body: Font {
        Font.body
    }
}
