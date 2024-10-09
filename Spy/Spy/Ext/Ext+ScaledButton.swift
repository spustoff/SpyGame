//
//  Ext+ScaledButton.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

struct ScaledButton: ButtonStyle {
    
    @AppStorage("is_vibration") var is_vibration: Bool = false
    
    var scaling: CGFloat
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .scaleEffect(configuration.isPressed ? scaling : 1)
            .animation(.easeInOut, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { value in
                
                if is_vibration {
                    
                    if value {
                        
                        generator.impactOccurred()
                    }
                }
            }
    }
}
