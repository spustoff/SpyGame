//
//  Ext+AnimatedScale.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

struct AnimatedScale: ViewModifier {
    
    @State private var isAnimated: Bool = false

    func body(content: Content) -> some View {
        
        content
            .scaleEffect(isAnimated ? 1 : 0.95)
            .opacity(isAnimated ? 1 : 0)
            .ignoresSafeArea()
            .onAppear {
                
                withAnimation(.spring()) {
                    
                    isAnimated = true
                }
            }
    }
}

