//
//  SpyCard.swift
//  Spy
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct SpyCard: View {
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 5)
            
            VStack(spacing: 50) {
                
                Image(systemName: "eye.fill")
                    .foregroundColor(.white.opacity(0.06))
                    .font(.system(size: 180, weight: .regular))
                    .overlay (
                    
                        VStack(alignment: .center, spacing: 5, content: {
                            
                            Text("You are a")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 16, weight: .regular))
                            
                            Text("Spy")
                                .foregroundColor(.white)
                                .font(.system(size: 32, weight: .semibold))
                        })
                    )
                
                HStack {
                    
                    Image(systemName: "hand.draw.fill")
                        .foregroundColor(.white.opacity(0.3))
                        .font(.system(size: 23, weight: .regular))
                    
                    Text("Swipe and pass to the next")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 14, weight: .regular))
                }
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(colors: [Color("primary"), Color("bgRed"), Color("bgRed"), Color("bgRed")], startPoint: .topTrailing, endPoint: .bottomLeading)))
        .overlay (
            
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray.opacity(0.3))
        )
        .padding()
    }
}

#Preview {
    SpyCard()
}
