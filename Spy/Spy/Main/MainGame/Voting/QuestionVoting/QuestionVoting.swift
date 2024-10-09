//
//  QuestionVoting.swift
//  Spy
//
//  Created by Вячеслав on 11/22/23.
//

import SwiftUI

struct QuestionVoting: View {
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        
        ZStack {
            
//            Color("bg")
//                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    VStack(alignment: .center, spacing: 2, content: {
                        
                        Text(viewModel.PlayerWithMostVotes?.playerName ?? "nil")
                            .foregroundColor(.white)
                            .font(.system(size: 21, weight: .semibold))
                        
                        Text("What location are we in?")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 15, weight: .regular))
                    })
                    
                    HStack {
                        
                        Button(action: {
                            
                            viewModel.currentVotingStep = .result
                            
                        }, label: {
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("bezhev"))
                                .font(.system(size: 21, weight: .semibold))
                        })
                        
                        Spacer()
                        
                        Image(viewModel.PlayerWithMostVotes?.playerPhoto ?? "avatar_name")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }
                }
                .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        
                        ForEach(viewModel.shuffledLocations, id: \.self) { index in
                            
                            Button(action: {
                                
                                viewModel.selectedLocationByPlayer = index
                                
                            }, label: {
                                
                                HStack {
                                    
                                    Circle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 40, height: 40)
                                        .overlay (
                                        
                                            Image(systemName: "person")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 13, weight: .regular))
                                        )
                                    
                                    Text(index.location ?? "nil")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15, weight: .medium))
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .stroke(viewModel.selectedLocationByPlayer == index ? Color("primary") : Color.gray.opacity(0.4), lineWidth: 2)
                                        .frame(width: 18, height: 18)
                                        .overlay (
                                        
                                            Circle()
                                                .fill(Color("primary"))
                                                .frame(width: 14, height: 14)
                                                .opacity(viewModel.selectedLocationByPlayer == index ? 1 : 0)
                                        )
                                }
                                .padding(.horizontal)
                                .frame(height: 65)
                                .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                                .overlay (
                                
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color("primary"), lineWidth: 2)
                                        .opacity(viewModel.selectedLocationByPlayer == index ? 1 : 0)
                                )
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                        }
                    }
                    .padding(1)
                }
                
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
                        
                        viewModel.getResultOfGame(isByLocationFound: true)
                        
                    }, label: {
                        
                        Text("SELECT")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .opacity(viewModel.selectedLocationByPlayer == nil ? 0.5 : 1)
                    .disabled(viewModel.selectedLocationByPlayer == nil ? true : false)
                }
                .padding(.top, 5)
            }
            .frame(height: UIScreen.main.bounds.height / 1.3)
        }
        .onAppear {
            
            let allLocations = viewModel.selectedSet.compactMap { $0.locations }.flatMap { $0 }
            viewModel.shuffledLocations = allLocations.isEmpty ? [
                Location(id: 1, location: "turkey", hints: []),
                Location(id: 2, location: "america", hints: []),
                Location(id: 3, location: "bali", hints: []),
                Location(id: 4, location: "spain", hints: [])
            ].shuffled() : allLocations
        }
    }
}

#Preview {
    QuestionVoting(viewModel: MainViewModel())
}
