//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05/08/2024.
//

import SwiftUI

extension View {
    func cornered(_ radius: CGFloat) -> some View {
        clipShape(
            .rect(
                cornerRadii: RectangleCornerRadii(
                    topLeading: radius,
                    bottomLeading: radius,
                    bottomTrailing: radius,
                    topTrailing: radius
                )
            )
        )
    }
}

public extension ThemeConstants {
    static var corners: Corners {
        Corners(step: 2)
    }
}

public struct Corners {
    let step: CGFloat
}

public extension Corners {
    var xxSmall: CGFloat {
        step
    }

    var xSmall: CGFloat {
        step * 2
    }

    var xmSmall: CGFloat {
        step * 3
    }

    var small: CGFloat {
        step * 4
    }

    var mediumS: CGFloat {
        step * 5
    }

    var medium: CGFloat {
        step * 8
    }

    var large: CGFloat {
        step * 9
    }

    var huge: CGFloat {
        step * 20
    }
}
