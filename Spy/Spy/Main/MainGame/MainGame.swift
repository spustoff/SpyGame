//
//  MainGame.swift
//  Spy
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct MainGame: View {
    
    @StateObject var viewModel: MainViewModel
    
    @State var isViewRole: Bool = false
    @State var isRulesAtTimer: Bool = false
    
    @Environment(\.presentationMode) var router
    
    var body: some View {
        
        ZStack {
            
            Color.bgPrime.ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text(viewModel.gameTypes.text)
                        .foregroundColor(.white)
                        .font(.system(size: 21, weight: .semibold))
                    
                    HStack {
                        
                        Button(action: {
                            
                            viewModel.gameFinished()
                            
                            router.wrappedValue.dismiss()
                            
                        }, label: {
                            Icon(image: "xmark")
                        })
                        
                        Spacer()
                        
                        if (viewModel.gameTypes == .timer || viewModel.gameTypes == .cards) {
                            
                            HStack {
                                
                                Button(action: {
                                    
                                    viewModel.isActiveTimer = false
                                    
                                    isRulesAtTimer = true
                                    
                                }, label: {
                                    
                                    Image("rules.icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 31, height: 31)
                                })
                                
                                Button(action: {
                                    
                                    viewModel.isActiveTimer = false
                                    
                                    isViewRole = true
                                    
                                }, label: {
                                    
                                    Image("persons.icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 31, height: 31)
                                })
                            }
                        }
                    }
                }
                .padding()
                .frame(height: 50)
                
                viewModel.getGameSteps()
            }
        }
        .sheet(isPresented: $isViewRole, content: {
            
            ViewRoles(viewModel: viewModel)
        })
        .sheet(isPresented: $isRulesAtTimer, content: {
            
            RulesView(isForGame: false, isTopBar: true, playAction: {})
        })
        .sheet(isPresented: $viewModel.isPaywall, content: {
            
            PaywallView()
        })
        .overlay (
        
            VotingView(viewModel: viewModel)
        )
    }
}

#Preview {
    MainGame(viewModel: MainViewModel())
}
