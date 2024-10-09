//
//  MainView.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color("darkBlue")
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0, content: {
                
                HStack {
                    
                    NavigationLink(destination: {
                        
                        SettingsView()
                            .navigationBarBackButtonHidden()
                        
                    }, label: {
                        
                        Image("gear.icon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                    })
                    
                    Spacer()
                    
                    NavigationLink(destination: {
                        
                        RulesView(isForGame: false, isTopBar: true, playAction: {})
                            .navigationBarBackButtonHidden()
                        
                    }, label: {
                        
                        Image("rules.icon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                    })
                    
                    NavigationLink(destination: {
                        
                        HistoryView()
                            .navigationBarBackButtonHidden()
                        
                    }, label: {
                        
                        Image("rounds.icon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                    })
                }
                
                Image("logo_big")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 220, height: 220)
                
                Spacer()
            })
            .padding()
            
            VStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.4))
                    .frame(width: 50, height: 5)
                
                viewModel.manageViews()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Rectangle().fill(Color("bg")).cornerRadius(radius: 25, corners: [.topLeft, .topRight]).ignoresSafeArea())
            .frame(maxHeight: .infinity, alignment: .bottom)
            .animation(.spring(), value: viewModel.currentStep)
            .if(viewModel.currentStep == .pickAvatar) { view in
                
                view
                    .ignoresSafeArea(.all, edges: .bottom)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isGame, content: {
            
            MainGame(viewModel: viewModel)
        })
        .sheet(isPresented: $viewModel.isPaywall, content: {
            
            PaywallView()
        })
        .sheet(isPresented: $viewModel.isReviewView, content: {
            
            ReviewView()
        })
        .fullScreenCover(isPresented: $viewModel.isHistory, content: {
            
            if let item = viewModel.gameFinishedHistoryModel {
                
                HistoryDetail(item: item)
            }
        })
    }
}

#Preview {
    MainView()
}
