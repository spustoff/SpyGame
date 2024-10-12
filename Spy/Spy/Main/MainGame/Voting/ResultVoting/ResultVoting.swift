//
//  ResultVoting.swift
//  Spy
//
//  Created by Вячеслав on 11/22/23.
//

import SwiftUI

struct ResultVoting: View {
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        
        ZStack {
            
//            Color("bg")
//                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("Voting Result")
                        .foregroundColor(.textWhite)
                        .font(.system(size: 19, weight: .bold))
                    
                    HStack {
                        
                        Button(action: {
                            
                            viewModel.currentVotingStep = .main
                            
                        }, label: {
                            Icon(image: "xmark")
                        })
                        
                        Spacer()
                    }
                }
                .padding()
                
                VStack(alignment: .center, spacing: 8, content: {
                    
                    Image(viewModel.PlayerWithMostVotes?.playerPhoto ?? "avatar_name")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 96)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .center, spacing: 2, content: {
                        
                        Text("\(viewModel.PlayerWithMostVotes?.playerName ?? "Eduardo") ")
                            .foregroundColor(Color.second)
                            .font(.system(size: 34, weight: .semibold)) +
                        
                        Text("is supposedly a spy")
                            .foregroundColor(.textWhite)
                            .font(.system(size: 34, weight: .semibold))
                    })
                    .multilineTextAlignment(.center)
                    
                    Text("You have a chance to prove you're not a spy, pick a location that has players in it")
                        .foregroundColor(.textWhite60)
                        .font(.system(size: 17, weight: .regular))
                        .multilineTextAlignment(.center)
                })
                
                HStack {
                    
                    Button(action: {
                        
                        viewModel.getResultOfGame(isByLocationFound: false)
                        
                    }, label: {
                        
                        Text("SURRENDER")
                            .foregroundColor(Color.prime)
                            .font(.system(size: 17, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.bgCell))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    
                    Button(action: {
                        
                        viewModel.currentVotingStep = .question
                        
                    }, label: {
                        PrimeButton(text: NSLocalizedString("CARDS", comment: ""))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                }
                .padding(.top, 45)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        ResultVoting(viewModel: MainViewModel())
    }
}
