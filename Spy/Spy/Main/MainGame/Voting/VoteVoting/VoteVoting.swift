//
//  VoteVoting.swift
//  Spy
//
//  Created by Вячеслав on 11/20/23.
//

import SwiftUI

struct VoteVoting: View {
    
    @StateObject var viewModel: MainViewModel
    
    @State private var counterVibro = 0
    
    var body: some View {
        
        ZStack {
            
//            Color("bg")
//                .ignoresSafeArea()
            
            VStack {
                

                
                ZStack(alignment: .top) {
                    
                    VStack(alignment: .center, spacing: 2, content: {
                        
                        if viewModel.currentPlayerIndex >= 0 && viewModel.currentPlayerIndex < viewModel.getActivePlayers().count {
                            
                            Text(viewModel.getActivePlayers()[viewModel.currentPlayerIndex].playerName)
                                .foregroundColor(.white)
                                .font(.system(size: 19, weight: .bold))
                        }
                        
                        Text("Who do you think is a spy?")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 15, weight: .regular))
                    })
                    .onChange(of: viewModel.getActivePlayers()) { players in
                    
                        print("players2: \n\(players)")
                    }
                    
                    HStack {
                        
                        Button(action: {
                            
                            viewModel.currentVotingStep = .main
                            
                        }, label: {
                            Icon(image: "xmark")
                        })
                        
                        Spacer()
                        
                        Image(viewModel.getActivePlayers()[viewModel.currentPlayerIndex].playerPhoto)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.top)
                
                TabView(selection: $viewModel.currentPlayerIndex) {
                    
                    ForEach(viewModel.getActivePlayers().indices, id: \.self) { index in
                        
                        let currentPlayer = viewModel.getActivePlayers()[index]
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            VStack {
                                
                                VStack {

                                    ForEach(viewModel.getActivePlayers().filter { $0.id != currentPlayer.id }, id: \.id) { otherPlayer in
                                        
                                        Button(action: {
                                            counterVibro += 1
                                            withAnimation(.spring()) {
                                                
                                                viewModel.selectedForPlayer = otherPlayer.id
                                                viewModel.selectedByPlayer = currentPlayer.id
                                            }
                                            
                                        }) {
                                            
                                            HStack {
                                                
                                                Image(otherPlayer.playerPhoto)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                
                                                Text(otherPlayer.playerName)
                                                    .foregroundColor(.textWhite)
                                                    .font(.system(size: 17, weight: .medium))
                                                
                                                Spacer()
                                                
                                                Icon(image: viewModel.selectedForPlayer == otherPlayer.id ? "button.programmable" : "circle")
                                                
                                            }
                                            .padding(.horizontal, 12)
                                            .frame(height: 60)
                                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                                            .overlay (
                                            
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.prime, lineWidth: 2)
                                                    .opacity(viewModel.selectedForPlayer == otherPlayer.id ? 1 : 0)
                                            )
                                        }
                                        .buttonStyle(ScaledButton(scaling: 0.9))
                                    }
                                    
                                    Spacer()
                                }
                                .tag(index)
                                .padding(.top)
                                .padding(1)
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: UIScreen.main.bounds.height / 2)
                .onChange(of: viewModel.currentPlayerIndex) { _ in
                 
                    viewModel.selectedForPlayer = 0
//                    viewModel.selectedByPlayer = 0
                }
                
                HStack {
                    
                    ForEach(0..<viewModel.getActivePlayers().count, id: \.self) { index in
                        
                        Circle()
                            .fill(viewModel.currentPlayerIndex >= index ? Color.prime : .textWhite40)
                            .frame(width: 8, height: 8)
                    }
                }
                
                HStack {
                    
                    Button(action: {
                        counterVibro += 1
                        guard viewModel.currentPlayerIndex >= 0 else { return }
                        
                        viewModel.selectedForPlayer = 0
                        
                        withAnimation(.spring()) {
                            
                            viewModel.currentPlayerIndex -= 1
                        }
                        
                    }, label: {
                        
                        HStack {
                            Image(systemName: "arrow.left")
                            
                            Text("PREVIOUS")
                        }
                        .foregroundColor(Color.prime)
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.bgCell))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .opacity(viewModel.currentPlayerIndex <= 0 ? 0.5 : 1)
                    .disabled(viewModel.currentPlayerIndex <= 0 ? true : false)
                    
                    let isDis = viewModel.selectedForPlayer == 0
                    Button(action: {
                        counterVibro += 1
                        withAnimation(.spring()) {
                            
                            viewModel.vote(for: viewModel.selectedForPlayer, by: viewModel.selectedByPlayer)
                        }
                        
                    }, label: {
                        
                        Text("SELECT")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(isDis ? .textWhite40 : .textWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 26).fill(LinearGradient(colors: [isDis ? Color.bgButtonDisabled : Color.primeTopTrailGrad, isDis ? Color.bgButtonDisabled : Color.primeBotLeadGrad], startPoint: .topTrailing, endPoint: .bottomLeading)))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .opacity(isDis ? 0.5 : 1)
                    .disabled(isDis ? true : false)
                }
                .padding(.top, 8)
            }
        }
        .sensoryFeedbackMod(trigger: $counterVibro)
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        VoteVoting(viewModel: MainViewModel())
    }
}
