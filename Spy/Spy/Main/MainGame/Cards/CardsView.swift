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
                    
                    VStack(alignment: .center, spacing: 15, content: {
                        
                        HStack {
                            
                            Image(index.playerPhoto)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 45)
                            
                            Text(index.playerName)
                                .foregroundColor(Color("bezhev"))
                                .font(.system(size: 28, weight: .semibold))
                        }
                        
                        Text("Your card")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .medium))
                        
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
                    
                    Text("START THE GAME")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                        .padding()
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                
            } else {
                
                HStack {
                    
                    Button(action: {
                        
                        viewModel.manageControlGame(buttonType: .minus)
                        
                    }, label: {
                        
                        Image(systemName: "arrow.left")
                            .foregroundColor(viewModel.currentCard == 1 ? .gray.opacity(0.5) : Color("bezhev"))
                            .font(.system(size: 22, weight: .semibold))
                    })
                    .disabled(viewModel.currentCard == 1 ? true : false)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        ScrollViewReader { value in
                            
                            HStack {
                                
                                ForEach(viewModel.playerNames, id: \.id) { index in
                                
                                    Button(action: {
                                        
                                        viewModel.currentCard = index.id
                                        
                                    }, label: {
                                        
                                        VStack(alignment: .center, spacing: 5, content: {
                                            
                                            Text(index.playerName)
                                                .foregroundColor(Color("bezhev"))
                                                .font(.system(size: 15, weight: .regular))
                                            
                                            Text("Player \(index.id) / \(viewModel.playerNames.count)")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 12, weight: .regular))
                                        })
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("bgGray")))
                                        .overlay (
                                        
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color("primary"), lineWidth: 2)
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
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(viewModel.currentCard == viewModel.playerNames.count ? .gray.opacity(0.5) : Color("bezhev"))
                            .font(.system(size: 22, weight: .semibold))
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
    CardsView(isPlayButton: true, viewModel: MainViewModel())
}
