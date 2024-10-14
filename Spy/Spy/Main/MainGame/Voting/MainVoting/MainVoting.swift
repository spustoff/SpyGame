//
//  MainVoting.swift
//  Spy
//
//  Created by Вячеслав on 11/20/23.
//

import SwiftUI

struct MainVoting: View {
    
    @StateObject var viewModel: MainViewModel
    
    @State private var counterVibro = 0
    
    var body: some View {
        
        VStack(spacing: 6) {
            
            ZStack {
                
                Text("Voting")
                    .foregroundColor(.white)
                    .font(.system(size: 19, weight: .bold))
                
                HStack {
                    
                    if viewModel.timeRemaining > 1 {
                        
                        Button(action: {
                            
                            viewModel.closeVotingModal()
                            
                        }, label: {
                            Icon(image: "xmark")
                        })
                    }
                    
                    Spacer()
                }
            }
            .padding([.top, .horizontal])
            
            Image("spy img")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 208, height: 208)
            
            VStack(alignment: .center, spacing: 8, content: {
                
                Text("Who's a spy?")
                    .foregroundColor(Color.second)
                    .font(.system(size: 34, weight: .semibold))
                    .multilineTextAlignment(.center)
                
                Text(NSLocalizedString("Take turns voting for the person you think is a spy and find out the result of your choice", comment: ""))
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .medium))
                    .multilineTextAlignment(.center)
            })
            .padding(.horizontal)
            
            HStack {
                
                if viewModel.timeRemaining > 1 {
                    
                    Button(action: {
                        counterVibro += 1
                        viewModel.closeVotingModal()
                        
                    }, label: {
                        
                        HStack {
                            
                            Image(systemName: "play.fill")
                            
                            Text("CANCEL")
//                            Text("PLAY")
                        }
                        .foregroundColor(Color.prime)
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.bgCell))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                }
                
                Button(action: {
                    counterVibro += 1
                    viewModel.currentVotingStep = .voting
                    
                }, label: {
                    PrimeButton(text: NSLocalizedString("VOTE", comment: ""))
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
            }
            .padding(.top, 45)
        }
        .sensoryFeedbackMod(trigger: $counterVibro)
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        MainVoting(viewModel: MainViewModel())
    }
}
