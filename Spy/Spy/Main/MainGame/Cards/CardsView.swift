//
//  CardsView.swift
//  Spy
//
//  Created by Вячеслав on 11/19/23.
//

import SwiftUI

struct CardsView: View {
    
    @Environment(\.presentationMode) var router
    
    let isPlayButton: Bool
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        
        VStack {
            
            TabView(selection: $viewModel.currentCard,
                    content:  {
                
                ForEach(viewModel.playerNames, id: \.id) { index in
                    
                    VStack(alignment: .center, spacing: 16, content: {
                        
                        VStack(spacing: 8) {
                            HStack(spacing: 16) {
                                
                                Image(index.playerPhoto)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 48, height: 48)
                                
                                Text(index.playerName)
                                    .foregroundColor(Color.second)
                                    .font(.system(size: 34, weight: .semibold))
                            }
                            
                            Text("Your card")
                                .foregroundColor(.textWhite)
                                .font(.system(size: 17, weight: .medium))
                        }
                        
                        if viewModel.isShowCard && viewModel.currentCard == index.id {
                            
                            if index.playerRole != "Spy" {
                                
                                Button(action: {
                                    
                                    viewModel.isShowCard = false
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        
                                        viewModel.manageControlGame(buttonType: .plus)
                                    }
                                    
                                }, label: {
                                    
                                    if let location = viewModel.gameLocation {
                                        
                                        CitizenCard(viewModel: viewModel, location: location, player: index)
                                            .modifier(AnimatedScale())
                                    }
                                })
                                .buttonStyle(ScaledButton(scaling: 0.8))
                                
                            } else if index.playerRole == "Spy" {
                                
                                Button(action: {
                                    
                                    viewModel.isShowCard = false
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        
                                        viewModel.manageControlGame(buttonType: .plus)
                                    }
                                    
                                }, label: {
                                    
                                    SpyCard()
                                        .modifier(AnimatedScale())
                                })
                                .buttonStyle(ScaledButton(scaling: 0.8))
                            }
                            
                        } else {
                            
                            Button(action: {
                                
                                viewModel.isShowCard = true
                                
                            }, label: {
                                
                                DefaultCard()
                                    .modifier(AnimatedScale())
                            })
                            .buttonStyle(ScaledButton(scaling: 0.8))
                        }
                    })
                }
            })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            if viewModel.currentCard == viewModel.playerNames.count && isPlayButton && viewModel.isShowCard == false && viewModel.isLastCard {
                
                Button(action: {
                    
                    viewModel.gameTypes = .timer
                    
                }, label: {
                    
                    PrimeButton(text: NSLocalizedString("START THE GAME", comment: ""))
//                    Text("START THE GAME")
//                        .foregroundColor(.white)
//                        .font(.system(size: 16, weight: .medium))
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 50)
//                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
//                        .padding()
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                
            } else {
                
                HStack {
                    
                    Button(action: {
                        
                        viewModel.manageControlGame(buttonType: .minus)
                        
                    }, label: {
                        Image("arrow.left")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(viewModel.currentCard == 1 ? Color.second.opacity(0.4) : Color.second)
                    })
                    .disabled(viewModel.currentCard == 1 ? true : false)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        ScrollViewReader { value in
                            
                            HStack {
                                
                                ForEach(viewModel.playerNames, id: \.id) { index in
                                
                                    Button(action: {
                                        
                                        viewModel.currentCard = index.id
                                        
                                    }, label: {
                                        
                                        VStack(alignment: .center, spacing: 0, content: {
                                            
                                            Text(index.playerName)
                                                .foregroundColor(Color.second)
                                                .font(.system(size: 15, weight: .regular))
                                            
                                            Text("Player \(index.id) / \(viewModel.playerNames.count)")
                                                .foregroundColor(.textWhite60)
                                                .font(.system(size: 11, weight: .regular))
                                        })
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                                        .overlay (
                                        
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.prime, lineWidth: 2)
                                                .opacity(viewModel.currentCard == index.id ? 1 : 0)
                                        )
                                        .onChange(of: viewModel.currentCard) { target in
                                            
                                            withAnimation(.spring()) {
                                                
                                                value.scrollTo(target, anchor: .top)
                                            }
                                        }
                                    })
                                    .buttonStyle(ScaledButton(scaling: 0.9))
                                }
                                .offset(x: viewModel.currentCard == 1 ? UIScreen.main.bounds.width / 3.5 : viewModel.currentCard == viewModel.playerNames.count ? -45 : 0)
                            }
                            .padding(1)
                        }
                    }
                    .animation(.easeInOut, value: viewModel.currentCard)
                    
                    Button(action: {
                        
                        viewModel.manageControlGame(buttonType: .plus)
                        
                    }, label: {
                        
                        Image("arrow.forward")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(viewModel.currentCard == viewModel.playerNames.count ? Color.second.opacity(0.4) : Color.second)
                    })
                    .disabled(viewModel.currentCard == viewModel.playerNames.count ? true : false)
                }
                .padding()
            }
        }
        .onChange(of: viewModel.currentCard) { newValue in
                
            viewModel.isShowCard = false
        }
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        CardsView(isPlayButton: true, viewModel: MainViewModel())
    }
}
