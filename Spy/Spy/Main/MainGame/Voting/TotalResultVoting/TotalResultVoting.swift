//
//  TotalResultVoting.swift
//  Spy
//
//  Created by Вячеслав on 11/22/23.
//

import SwiftUI

struct TotalResultVoting: View {
    
    @StateObject var viewModel: MainViewModel
    
    @State private var counterVibro = 0
    
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
                    
                    Text(NSLocalizedString("A spy is exposed!", comment: ""))
                        .foregroundColor(Color.prime)
                        .font(.system(size: 17, weight: .medium))
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .center, spacing: 2, content: {
                        
                        Text("\(viewModel.PlayerWithMostVotes?.playerName ?? "Eduardo") ")
                            .foregroundColor(Color.second)
                            .font(.system(size: 34, weight: .semibold)) +
                        
                        Text(NSLocalizedString("is out of the game!", comment: ""))
                            .foregroundColor(.textWhite)
                            .font(.system(size: 34, weight: .semibold))
                    })
                    .multilineTextAlignment(.center)
                    
                    Text(NSLocalizedString("He didn't know what location you were in. Identify the other spies.", comment: ""))
                        .foregroundColor(.textWhite60)
                        .font(.system(size: 17, weight: .regular))
                        .multilineTextAlignment(.center)
                })
                
                Button(action: {
                    counterVibro += 1
                    viewModel.closeVotingModal()
                    
                }, label: {
                    PrimeButton(text: NSLocalizedString("CONTINUE PLAYING", comment: ""))
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .padding(.top, 45)
            }
            .sensoryFeedbackMod(trigger: $counterVibro)
        }
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        TotalResultVoting(viewModel: MainViewModel())
    }
}
