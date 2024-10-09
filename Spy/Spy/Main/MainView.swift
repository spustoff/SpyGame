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
            
            Color.bgSecond.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    
                    NavigationLink(destination: {
                        
                        SettingsView()
                            .navigationBarBackButtonHidden()
                        
                    }, label: {
                        Icon(image: "line.3.horizontal")
                    })
                    
                    Spacer()
                    
                    NavigationLink(destination: {
                        
                        RulesView(isForGame: false, isTopBar: true, playAction: {})
                            .navigationBarBackButtonHidden()
                        
                    }, label: {
                        Icon(image: "info.bubble")
                    })
                    
                    NavigationLink(destination: {
                        
                        HistoryView()
                            .navigationBarBackButtonHidden()
                        
                    }, label: {
                        Icon(image: "clock.arrow.circlepath")
                    })
                }
                
                .padding(.horizontal)
                .padding(.top, 20)
                .font(.system(size: 21))
                .foregroundColor(.second)
                
                Spacer()
            }
            
            VStack {
                Image("spy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 208, height: 208)
                VStack {
                    viewModel.manageViews()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Rectangle().fill(Color.bgPrime).cornerRadius(radius: 16, corners: [.topLeft, .topRight]).ignoresSafeArea())
                .frame(maxHeight: .infinity, alignment: .bottom)
                .animation(.spring(), value: viewModel.currentStep)
                .if(viewModel.currentStep == .pickAvatar) { view in
                    
                    view
                        .ignoresSafeArea(.all, edges: .bottom)
                }
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
