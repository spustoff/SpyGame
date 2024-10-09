//
//  VoteVoting.swift
//  Spy
//
//  Created by Вячеслав on 11/20/23.
//

import SwiftUI

struct VoteVoting: View {
    
    @StateObject var viewModel: MainViewModel
    
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
                                .font(.system(size: 21, weight: .semibold))
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
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("bezhev"))
                                .font(.system(size: 21, weight: .semibold))
                        })
                        
                        Spacer()
                        
                        Image(viewModel.getActivePlayers()[viewModel.currentPlayerIndex].playerPhoto)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
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
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15, weight: .medium))
                                                
                                                Spacer()
                                                
                                                Circle()
                                                    .stroke(viewModel.selectedForPlayer == otherPlayer.id ? Color("primary") : Color.gray.opacity(0.4), lineWidth: 2)
                                                    .frame(width: 18, height: 18)
                                                    .overlay (
                                                    
                                                        Circle()
                                                            .fill(Color("primary"))
                                                            .frame(width: 14, height: 14)
                                                            .opacity(viewModel.selectedForPlayer == otherPlayer.id ? 1 : 0)
                                                    )
                                            }
                                            .padding(.horizontal)
                                            .frame(height: 65)
                                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                                            .overlay (
                                            
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color("primary"), lineWidth: 2)
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
                            .fill(viewModel.currentPlayerIndex >= index ? Color("primary") : .gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                
                HStack {
                    
                    Button(action: {
                        
                        guard viewModel.currentPlayerIndex >= 0 else { return }
                        
                        viewModel.selectedForPlayer = 0
                        
                        withAnimation(.spring()) {
                            
                            viewModel.currentPlayerIndex -= 1
                        }
                        
                    }, label: {
                        
                        HStack {
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(Color("primary"))
                                .font(.system(size: 16, weight: .medium))
                            
                            Text("PREVIOUS")
                                .foregroundColor(Color("primary"))
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color("bgGray")))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .opacity(viewModel.currentPlayerIndex <= 0 ? 0.5 : 1)
                    .disabled(viewModel.currentPlayerIndex <= 0 ? true : false)
                    
                    Button(action: {
                        
                        withAnimation(.spring()) {
                            
                            viewModel.vote(for: viewModel.selectedForPlayer, by: viewModel.selectedByPlayer)
                        }
                        
                    }, label: {
                        
                        Text("SELECT")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .opacity(viewModel.selectedForPlayer == 0 ? 0.5 : 1)
                    .disabled(viewModel.selectedForPlayer == 0 ? true : false)
                }
                .padding(.top, 20)
            }
        }
    }
}

#Preview {
    VoteVoting(viewModel: MainViewModel())
}
