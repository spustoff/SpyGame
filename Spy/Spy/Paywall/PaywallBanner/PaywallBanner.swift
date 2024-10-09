//
//  PaywallBanner.swift
//  Spy
//
//  Created by Вячеслав on 12/1/23.
//

import SwiftUI

struct PaywallBanner: View {
    
    var tapAction: () -> Void
    var closeAction: () -> Void
    
    var body: some View {
        
        Button(action: {
            
            tapAction()
            
        }, label: {
            
            VStack(alignment: .leading, spacing: 12, content: {
                
                VStack(alignment: .leading, spacing: 5, content: {
                    
                    Text("Want to turn off the ads?")
                        .foregroundColor(Color("bezhev"))
                        .font(.system(size: 25, weight: .semibold))
                        .multilineTextAlignment(.leading)
                    
                    Text("Click here to improve your owl\nexperience in this game")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .regular))
                        .multilineTextAlignment(.leading)
                })
                
                Text("DISABLE ADS")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.horizontal, 12)
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
            })
            .padding([.vertical, .leading])
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bg")))
            .overlay (
            
                Image("ad")
                    .resizable()
                    .frame(width: 170, height: 145)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .cornerRadius(radius: 15, corners: .allCorners)
            )
            .overlay (
            
                VStack {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            
                            closeAction()
                            
                        }, label: {
                            
                            Image(systemName: "xmark")
                                .foregroundColor(Color("primary"))
                                .font(.system(size: 12, weight: .bold))
                                .frame(width: 27, height: 27)
                                .background(Circle().fill(Color("bgGray")))
                                .offset(x: 5, y: -5)
                        })
                    }
                    
                    Spacer()
                }
            )
        })
        .buttonStyle(ScaledButton(scaling: 0.9))
    }
}

#Preview {
    PaywallBanner(tapAction: {}, closeAction: {})
}
