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
                        .foregroundColor(.white)
                        .font(.system(size: 21, weight: .semibold))
                    
                    HStack {
                        
                        Button(action: {
                            
                            viewModel.currentVotingStep = .main
                            
                        }, label: {
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("bezhev"))
                                .font(.system(size: 21, weight: .semibold))
                        })
                        
                        Spacer()
                    }
                }
                .padding()
                
                VStack(alignment: .center, spacing: 20, content: {
                    
                    Image(viewModel.PlayerWithMostVotes?.playerPhoto ?? "avatar_name")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 133, height: 133)
                    
                    VStack(alignment: .center, spacing: 2, content: {
                        
                        Text("\(viewModel.PlayerWithMostVotes?.playerName ?? "")")
                            .foregroundColor(Color("bezhev"))
                            .font(.system(size: 34, weight: .semibold))
                        
                        Text("is supposedly a spy")
                            .foregroundColor(.white)
                            .font(.system(size: 34, weight: .semibold))
                            .multilineTextAlignment(.center)
                    })
                    
                    Text("You have a chance to prove you're not a spy, pick a location that has players in it")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 15, weight: .regular))
                        .multilineTextAlignment(.center)
                })
                
                HStack {
                    
                    Button(action: {
                        
                        viewModel.getResultOfGame(isByLocationFound: false)
                        
                    }, label: {
                        
                        Text("SURRENDER")
                            .foregroundColor(Color("primary"))
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 25).fill(Color("bgGray")))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    
                    Button(action: {
                        
                        viewModel.currentVotingStep = .question
                        
                    }, label: {
                        
                        Text("CARDS")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                }
                .padding(.top, 45)
            }
        }
    }
}

#Preview {
    ResultVoting(viewModel: MainViewModel())
}
