//
//  Ext+CustomProgressViewStyle.swift
//  Spy
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct CustomProgressViewStyle: ProgressViewStyle {
    
    var trackColor: Color
    var progressColor: Color
    var height: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        
        ZStack(alignment: .leading) {
            
            Capsule()
                .fill(trackColor)
                .frame(height: height)
            
            Capsule()
                .fill(progressColor)
                .frame(maxWidth: configuration.fractionCompleted != nil ? CGFloat(configuration.fractionCompleted!) * UIScreen.main.bounds.width : 0)
                .frame(height: height)
                .animation(.spring())
        }
        .cornerRadius(height / 2.0)
    }
}

