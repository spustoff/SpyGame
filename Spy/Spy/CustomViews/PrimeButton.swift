//
//  PrimeButton.swift
//  SpyGame
//
//  Created by Александр Печинкин on 09.10.2024.
//

import SwiftUI

struct PrimeButton: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.body.bold())
            .foregroundColor(.textWhite)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [Color.primeTopTrailGrad, Color.primeBotLeadGrad],
                               startPoint: .topTrailing,
                               endPoint: .bottomLeading)
            )
            .embedInCornRadius(cornradius: 16)
    }
}

#Preview {
    PrimeButton(text: "Continue")
}
