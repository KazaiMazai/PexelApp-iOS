//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06/08/2024.
//

import SwiftUI


public extension View {
    func modal<Destination: View, Bindable: Identifiable>(
        _ bindable: Binding<Bindable?>,
        @ViewBuilder destination: @escaping (_ value: Bindable, _ opacity: CGFloat) -> Destination) -> some View {
        
        modifier(ModalViewModifier(value: bindable, destination: destination))
    }
}

struct ModalViewModifier<Destination: View, Bindable: Identifiable>: ViewModifier {
    @State private var offset = CGSize.zero
    
    @Binding var value: Bindable?
    
    let destination: (_ value: Bindable, _ opacity: CGFloat) -> Destination
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .statusBarHidden(value != nil)
            
            if let value {
                Color.white
                    .ignoresSafeArea()
                    .opacity(offsetProgress)
                    .animation(.easeInOut, value: offsetProgress)
                
                destination(value, offsetProgress)
                    .offset(offset)
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                guard offsetLimit.isLess(than: absoluteOffset) else {
                                    withAnimation(.interactiveSpring(
                                        response: 0.6,
                                        dampingFraction: 0.7,
                                        blendDuration: 0.7)) {
                                            offset = .zero
                                        }
                                    offset = .zero
                                    return
                                }
                                
                                withAnimation(.interactiveSpring(
                                    response: 0.6,
                                    dampingFraction: 0.7,
                                    blendDuration: 0.7)) {
                                        offset = .zero
                                        self.value = nil
                                    }
                            }
                    )
            }
        }
    }
    
    private var absoluteOffset: CGFloat {
        max(abs(offset.width), abs(offset.height))
    }
    
  
    
    private let offsetLimit: CGFloat = 50
    
    private var offsetProgress: CGFloat {
        min(1.0, max(0.0, 1.0 - (absoluteOffset / (offsetLimit * 0.5))))
    }
}
