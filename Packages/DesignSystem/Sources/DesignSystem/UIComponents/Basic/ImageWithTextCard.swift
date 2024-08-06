//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06/08/2024.
//

import SwiftUI

public struct ImageWithTextCard: View {
    private let viewModel: ImageWithText.ViewModel
    
    public init(viewModel: ImageWithText.ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ImageWithText(viewModel: viewModel)
            .cornerRadius(.theme.corners.large)
            .shadow(.theme.largeDropShadow)
    }
}
