//
//  QuestionVoting.swift
//  Spy
//
//  Created by Вячеслав on 11/22/23.
//

import SwiftUI

struct QuestionVoting: View {
    
    @StateObject var viewModel: MainViewModel
    
    @State private var counterVibro = 0
    
    var body: some View {
        
        ZStack {
            
//            Color("bg")
//                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    VStack(alignment: .center, spacing: 2, content: {
                        
                        Text(viewModel.PlayerWithMostVotes?.playerName ?? "nil")
                            .foregroundColor(.white)
                            .font(.system(size: 19, weight: .bold))
                        
                        Text("What location are we in?")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 15, weight: .regular))
                    })
                    
                    HStack {
                        
                        Button(action: {
                            viewModel.currentVotingStep = .result
                            
                        }, label: {
                            Icon(image: "xmark")
                        })
                        
                        Spacer()
                        
                        Image(viewModel.PlayerWithMostVotes?.playerPhoto ?? "avatar_name")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }
                }
                .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        
                        ForEach(viewModel.shuffledLocations, id: \.self) { index in
                            
                            Button(action: {
                                counterVibro += 1
                                viewModel.selectedLocationByPlayer = index
                                
                            }, label: {
                                
                                HStack {
                                    
//                                    Circle()
//                                        .fill(Color.gray.opacity(0.1))
//                                        .frame(width: 40, height: 40)
//                                        .overlay (
//                                        
//                                            Image(systemName: "person")
//                                                .foregroundColor(.gray)
//                                                .font(.system(size: 13, weight: .regular))
//                                        )
                                    
                                    Text(index.location ?? "nil")
                                        .foregroundColor(.white)
                                        .font(.system(size: 17, weight: .medium))
                                    
                                    Spacer()
                                    
                                    Icon(image: viewModel.selectedLocationByPlayer == index ? "button.programmable" : "circle")
                                    
//                                    Circle()
//                                        .stroke(viewModel.selectedLocationByPlayer == index ? Color("primary") : Color.gray.opacity(0.4), lineWidth: 2)
//                                        .frame(width: 18, height: 18)
//                                        .overlay (
//                                        
//                                            Circle()
//                                                .fill(Color("primary"))
//                                                .frame(width: 14, height: 14)
//                                                .opacity(viewModel.selectedLocationByPlayer == index ? 1 : 0)
//                                        )
                                }
                                .padding(.horizontal, 12)
                                .frame(height: 60)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                                .overlay (
                                
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.prime, lineWidth: 2)
                                        .opacity(viewModel.selectedLocationByPlayer == index ? 2 : 0)
                                )
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                        }
                    }
                    .padding(1)
                }
                
                HStack {
                    
                    Button(action: {
                        counterVibro += 1
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
                        counterVibro += 1
                        viewModel.getResultOfGame(isByLocationFound: true)
                        
                    }, label: {
                        
                        PrimeButton(text: NSLocalizedString("SELECT", comment: ""))
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
        .sensoryFeedbackMod(trigger: $counterVibro)
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        QuestionVoting(viewModel: MainViewModel())
    }
}
