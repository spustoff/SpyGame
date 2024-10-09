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
            
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 5)
            
            VStack(spacing: 50) {
                
                VStack(alignment: .center, spacing: 15, content: {
                    
                    VStack(alignment: .center, spacing: 5, content: {
                        
                        Text("Location")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 16, weight: .regular))
                        
                        Text(location.location ?? "None")
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .semibold))
                            .multilineTextAlignment(.center)
                    })
                    
                    VStack(alignment: .center, spacing: 5, content: {
                        
                        Text("Role")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 16, weight: .regular))
                        
                        Text(player.playerRole)
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .semibold))
                            .multilineTextAlignment(.center)
                    })
                })
                .padding(.horizontal)
                
                VStack(spacing: 4) {
                    
                    Image(systemName: "hand.draw.fill")
                        .foregroundColor(.white.opacity(0.3))
                        .font(.system(size: 23, weight: .regular))
                    
                    Text("Swipe and pass to the next")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 14, weight: .regular))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(colors: [Color("blue"), Color("darkBlueGrad"), Color("darkBlueGrad")], startPoint: .topTrailing, endPoint: .bottomLeading)))
        .overlay (
            
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray.opacity(0.3))
        )
        .padding()
    }
}

#Preview {
    CitizenCard(viewModel: MainViewModel(), location: Location(id: 0, location: "asd", hints: []), player: PlayersModel(id: 1, playerName: "d[pas", playerPhoto: "d[sapk", playerRole: "Citizen2"))
}
