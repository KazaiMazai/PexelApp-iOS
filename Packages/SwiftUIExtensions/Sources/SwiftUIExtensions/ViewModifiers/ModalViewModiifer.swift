//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06/08/2024.
//

import SwiftUI


public extension View {
    func modal<Destination: View, Bindable: Hashable>(
        _ bindable: Binding<Bindable?>,
        animation: Animation,
        @ViewBuilder destination: @escaping (_ value: Bindable,
                                             _ interactivePresentationProgress: CGFloat) -> Destination) -> some View {
        
        modifier(ModalViewModifier(value: bindable, animation: animation, destination: destination))
    }
}

struct ModalViewModifier<Destination: View, Bindable: Hashable>: ViewModifier {
    private let offsetLimit: CGFloat = 50
    
    @State private var offset = CGSize.zero
    @Binding private(set) var value: Bindable?
    private(set) var animation: Animation
    let destination: (_ value: Bindable, _ presentationProgress: CGFloat) -> Destination
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .statusBarHidden(value != nil)
            
            if let value {
                Color.white
                    .ignoresSafeArea()
                    .opacity(interactivePresentationProgress)
                    .animation(.easeInOut, value: interactivePresentationProgress)
                
                destination(value, interactivePresentationProgress)
                    .offset(offset)
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                hideOfNeeded()
                            }
                    )
            }
        }
    }
    
    private func hideOfNeeded() {
        guard offsetLimit.isLess(than: absoluteOffset) else {
            withAnimation(animation) {
                offset = .zero
            }
            
            offset = .zero
            return
        }
        
        withAnimation(animation) {
            offset = .zero
            self.value = nil
        }
    }
    
    private var absoluteOffset: CGFloat {
        abs(offset.width) + abs(offset.height)
    }
    
    private var interactivePresentationProgress: CGFloat {
        min(1.0, max(0.0, 1.0 - (absoluteOffset / offsetLimit)))
    }
}
