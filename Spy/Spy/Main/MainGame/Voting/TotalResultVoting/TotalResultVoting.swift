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
                    .font(.system(size: 19, weight: .semibold))
                    .padding()
                    .padding(.bottom, 8)
                
                VStack(alignment: .center, spacing: 8, content: {
                    
                    Image(viewModel.PlayerWithMostVotes?.playerPhoto ?? "avatar_name")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 96)
                        .padding(.bottom, 8)
                    
                    Text("A spy is exposed!")
                        .foregroundColor(Color.prime)
                        .font(.system(size: 17, weight: .medium))
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .center, spacing: 2, content: {
                        
                        Text("\(viewModel.PlayerWithMostVotes?.playerName ?? "Eduardo") ")
                            .foregroundColor(Color.second)
                            .font(.system(size: 34, weight: .semibold)) +
                        
                        Text("is out of the game!")
                            .foregroundColor(.textWhite)
                            .font(.system(size: 34, weight: .semibold))
                    })
                    .multilineTextAlignment(.center)
                    
                    Text("He didn't know what location you were in. Identify the other spies.")
                        .foregroundColor(.textWhite60)
                        .font(.system(size: 17, weight: .regular))
                        .multilineTextAlignment(.center)
                })
                
                Button(action: {
                    
                    viewModel.closeVotingModal()
                    
                }, label: {
                    PrimeButton(text: NSLocalizedString("CONTINUE PLAYING", comment: ""))
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .padding(.top, 45)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        TotalResultVoting(viewModel: MainViewModel())
    }
}
