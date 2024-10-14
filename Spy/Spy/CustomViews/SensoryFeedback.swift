//
//  SensoryFeedback.swift
//  Spy
//
//  Created by Александр Печинкин on 12.10.2024.
//

import SwiftUI

struct SensoryFeedbackMod: ViewModifier {
    @Binding var trigger: Int
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .sensoryFeedback(.increase, trigger: trigger)
        } else {
            content
        }
    }
}

extension View {
    func sensoryFeedbackMod(trigger: Binding<Int>) -> some View {
        self.modifier(SensoryFeedbackMod(trigger: trigger))
    }
}
