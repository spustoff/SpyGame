//
//  TotalResultVoting.swift
//  Spy
//
//  Created by Вячеслав on 11/22/23.
//

import SwiftUI

struct TotalResultVoting: View {
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
       
        ZStack {
            
//            Color("bg")
//                .ignoresSafeArea()
            
            VStack {
                
                Text("Result")
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .semibold))
                    .padding()
                
                VStack(alignment: .center, spacing: 10, content: {
                    
                    Image(viewModel.PlayerWithMostVotes?.playerPhoto ?? "avatar_name")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 133, height: 133)
                    
                    Text("A spy is exposed!")
                        .foregroundColor(Color("primary"))
                        .font(.system(size: 16, weight: .regular))
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .center, spacing: 2, content: {
                        
                        Text("\(viewModel.PlayerWithMostVotes?.playerName ?? "Eduardo") ")
                            .foregroundColor(Color("bezhev"))
                            .font(.system(size: 34, weight: .semibold)) +
                        
                        Text("is out of the game!")
                            .foregroundColor(.white)
                            .font(.system(size: 34, weight: .semibold))
                    })
                    .multilineTextAlignment(.center)
                    
                    Text("He didn't know what location you were in. Identify the other spies.")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 15, weight: .regular))
                        .multilineTextAlignment(.center)
                })
                
                Button(action: {
                    
                    viewModel.closeVotingModal()
                    
                }, label: {
                    
                    Text("CONTINUE PLAYING")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .padding(.top, 45)
            }
        }
    }
}

#Preview {
    TotalResultVoting(viewModel: MainViewModel())
}
