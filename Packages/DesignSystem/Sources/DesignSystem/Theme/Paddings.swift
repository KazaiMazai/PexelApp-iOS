//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import SwiftUI

public extension CGFloat {
    static var theme: ThemeConstants.Type {
        ThemeConstants.self
    }
}
 
public enum ThemeConstants { }

public extension ThemeConstants {
    static var padddings: Padding {
        Padding(step: 8)
    }
}

public struct Padding {
    let step: CGFloat
}

public extension Padding {
    var xSmall: CGFloat {
        step / 4
    }
    
    var small: CGFloat {
        step / 2
    }
    
    var xsMedium: CGFloat {
        step * 0.75
    }
    
    var medium: CGFloat {
        step
    }
    
    var xMedium: CGFloat {
        step * 1.25
    }
    
    var xxMedium: CGFloat {
        step * 1.5
    }
    
    var large: CGFloat {
        step * 2
    }
    
    var xmLarge: CGFloat {
        step * 2.5
    }
    
    var xLarge: CGFloat {
        step * 3
    }
    
    var xxLarge: CGFloat {
        step * 4
    }
    
    var xxmLarge: CGFloat {
        step * 4.5
    }
    
    var xxxLarge: CGFloat {
        step * 5
    }
    
    var xxxxLarge: CGFloat {
        step * 6
    }
}
