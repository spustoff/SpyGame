//
//  DefaultCard.swift
//  Spy
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct DefaultCard: View {
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.2), lineWidth: 5)
                
                VStack(spacing: 50) {
                    
                    Image("spy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    HStack {
                        
                        Image(systemName: "hand.tap.fill")
                            .foregroundColor(.white.opacity(0.3))
                            .font(.system(size: 23, weight: .regular))
                        
                        Text("Tap on it")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 14, weight: .regular))
                    }
                }
            }
            .padding(30)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
            .overlay (
                
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.gray.opacity(0.3))
            )
        }
        .padding()
    }
}

#Preview {
    DefaultCard()
}
