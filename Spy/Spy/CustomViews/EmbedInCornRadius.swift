//
//  EmbedInCornRadius.swift
//  SpyGame
//
//  Created by Александр Печинкин on 09.10.2024.
//

import SwiftUI

struct EmbedInCornRadius: ViewModifier {
    var cornradius: CGFloat
    var topLead = true
    var topTrail = true
    var botTrail = true
    var botLead = true
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .clipShape(
                    .rect(
                        topLeadingRadius: topLead ? cornradius : 0,
                        bottomLeadingRadius: botLead ? cornradius : 0,
                        bottomTrailingRadius: botTrail ? cornradius : 0,
                        topTrailingRadius: topTrail ? cornradius : 0
                    )
                )
        } else {
            content
                .cornerRadius(cornradius)
        }
    }
}

extension View {
    func embedInCornRadius(cornradius: CGFloat, topLead: Bool = true, topTrail: Bool = true, botTrail: Bool = true, botLead: Bool = true) -> some View {
        self.modifier(EmbedInCornRadius(cornradius: cornradius, topLead: topLead, topTrail: topTrail, botTrail: botTrail, botLead: botLead))
    }
}

#Preview {
    Rectangle()
        .fill(Color.pink)
        .frame(width: 100, height: 100)
        .embedInCornRadius(cornradius: 12)
}
