//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07/08/2024.
//

import SwiftUI

public extension List {
    @ViewBuilder
    func refreshable(_ isRefreshable: Bool, perform action: @escaping @Sendable () async -> Void) -> some View {
        if isRefreshable {
            refreshable(action: action)
        } else {
            self
        }
    }
}
