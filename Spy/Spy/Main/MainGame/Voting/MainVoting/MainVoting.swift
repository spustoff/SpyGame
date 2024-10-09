//
//  MainVoting.swift
//  Spy
//
//  Created by Вячеслав on 11/20/23.
//

import SwiftUI

struct MainVoting: View {
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                Text("Voting")
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .semibold))
                
                HStack {
                    
                    if viewModel.timeRemaining > 1 {
                        
                        Button(action: {
                            
                            viewModel.closeVotingModal()
                            
                        }, label: {
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("bezhev"))
                                .font(.system(size: 21, weight: .semibold))
                        })
                    }
                    
                    Spacer()
                }
            }
            .padding()
            
            Image("spy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 222, height: 222)
            
            VStack(alignment: .center, spacing: 10, content: {
                
                Text("Who's a spy?")
                    .foregroundColor(Color("bezhev"))
                    .font(.system(size: 34, weight: .semibold))
                    .multilineTextAlignment(.center)
                
                Text(NSLocalizedString("Take turns voting for the person you think is a spy and find out the result of your choice", comment: ""))
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.center)
            })
            .padding()
            
            HStack {
                
                if viewModel.timeRemaining > 1 {
                    
                    Button(action: {
                        
                        viewModel.closeVotingModal()
                        
                    }, label: {
                        
                        HStack {
                            
                            Image(systemName: "play.fill")
                                .foregroundColor(Color("primary"))
                                .font(.system(size: 16, weight: .medium))
                            
                            Text("PLAY")
                                .foregroundColor(Color("primary"))
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color("bgGray")))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                }
                
                Button(action: {
                    
                    viewModel.currentVotingStep = .voting
                    
                }, label: {
                    
                    Text("VOTE")
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

#Preview {
    MainVoting(viewModel: MainViewModel())
}
