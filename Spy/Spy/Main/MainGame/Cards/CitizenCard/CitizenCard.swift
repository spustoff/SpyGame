//
//  CitizenCard.swift
//  Spy
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct CitizenCard: View {
    
    @StateObject var viewModel: MainViewModel
    
    let location: Location
    let player: PlayersModel
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.textWhite20, lineWidth: 6)
            
                VStack(alignment: .center, spacing: 16, content: {
                    
                    VStack(alignment: .center, spacing: 0, content: {
                        
                        Text("Location")
                            .foregroundColor(.textWhite60)
                            .font(.system(size: 15, weight: .regular))
                        
                        Text(location.location ?? "None")
                            .foregroundColor(.textWhite)
                            .font(.system(size: 34, weight: .semibold))
                            .multilineTextAlignment(.center)
                    })
                    
                    VStack(alignment: .center, spacing: 0, content: {
                        
                        Text("Role")
                            .foregroundColor(.textWhite60)
                            .font(.system(size: 15, weight: .regular))
                        
                        Text(player.playerRole)
                            .foregroundColor(.textWhite)
                            .font(.system(size: 34, weight: .semibold))
                            .multilineTextAlignment(.center)
                    })
                })
                .padding(.horizontal, 10)
            
            VStack {
                Spacer()
                HStack(spacing: 4) {
                    Icon(image: "hand.draw.fill")
//                    Image("hand.draw.fill")
//                        .resizable()
//                        .renderingMode(.template)
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 32, height: 32)
//                        .foregroundColor(.textWhite40)
                    
                    Text("Swipe and pass to the next")
                        .foregroundColor(.textWhite40)
                        .font(.system(size: 13, weight: .medium))
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.horizontal, 60)
            .padding(.bottom, 18)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 16).fill(LinearGradient(colors: [Color.bgCardTopTrailGrad, Color.bgCardBotLeadGrad], startPoint: .topTrailing, endPoint: .bottomLeading)))
        .overlay (
            
            RoundedRectangle(cornerRadius: 16)
                .stroke(.textWhite20)
        )
        .padding()
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        CitizenCard(viewModel: MainViewModel(), location: Location(id: 0, location: "asd", hints: []), player: PlayersModel(id: 1, playerName: "d[pas", playerPhoto: "d[sapk", playerRole: "Citizen2"))
    }
}
