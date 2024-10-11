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
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.textWhite20, lineWidth: 6)
                
                VStack(spacing: 50) {
                    
                    Image("spyMonoImg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    HStack(spacing: 4) {
                        Icon(image: "hand.tap.fill")
                        
                        Text("Tap on it")
                            .foregroundColor(.textWhite40)
                            .font(.system(size: 13, weight: .medium))
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.bgCell))
            .overlay (
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.textWhite20)
            )
        }
        .padding()
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        DefaultCard()
    }
}
