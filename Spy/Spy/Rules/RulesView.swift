//
//  RulesView.swift
//  Spy
//
//  Created by Вячеслав on 11/12/23.
//

import SwiftUI

struct RulesView: View {
    
    let isForGame: Bool
    let isTopBar: Bool
    var playAction: () -> Void
    
    @Environment(\.presentationMode) var router
    
    @StateObject var viewModel = RulesViewModel()
    
    var body: some View {
        
        ZStack {
            
            if isTopBar {
                
                Color("bg")
                    .ignoresSafeArea()
            }
            
            VStack {
                
                if isTopBar {
                    
                    ZStack {
                        
                        Text("Rules")
                            .foregroundColor(.white)
                            .font(.system(size: 21, weight: .semibold))
                        
                        HStack {
                            
                            Button(action: {
                                
                                router.wrappedValue.dismiss()
                                
                            }, label: {
                                
                                Image(systemName: isForGame ? "xmark" : "chevron.left")
                                    .foregroundColor(Color(isForGame ? "primary" : "bezhev"))
                                    .font(.system(size: 21, weight: .semibold))
                            })
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .padding(.top, isForGame ? 16 : 0)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack {
                        
                        ForEach(viewModel.rule_screens, id: \.id) { indexer in
                            
                            VStack(alignment: .leading, spacing: 15, content: {
                                
                                Text(NSLocalizedString(indexer.mainPoint, comment: ""))
                                    .foregroundColor(.white)
                                    .font(.system(size: 21, weight: .semibold))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                    
                                    ForEach(indexer.subPoints, id: \.id) { index in
                                        
                                        Button(action: {
                                            
                                            viewModel.current_rule = index.identifier
                                            viewModel.isDetail = true
                                            
                                        }, label: {
                                            
                                            VStack(alignment: .leading, spacing: 1, content: {
                                                
                                                Text("\(index.id) \(NSLocalizedString(index.title, comment: ""))")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .padding()
                                                
                                                Spacer()
                                                
                                                HStack {
                                                    
                                                    Image("\(index.id)")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 111, height: 111)
                                                        .cornerRadius(10)
                                                    
                                                    Spacer()
                                                }
                                            })
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("bgGray")))
                                        })
                                        .buttonStyle(ScaledButton(scaling: 0.9))
                                    }
                                }
                                .padding([.horizontal, .bottom])
                            })
                        }
                    }
                }
                
                Spacer()
                
                bottomTab()
            }
        }
        .background(Color("bg"))
        .sheet(isPresented: $viewModel.isDetail, content: {
            
            RulesDetail(viewModel: viewModel)
        })
    }
    
    @ViewBuilder
    func bottomTab() -> some View {
        
        if isForGame {
            
            Button(action: {
                
                withAnimation(.spring()) {
                    
                    playAction()
                }
                
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
            
            Button(action: {
                
                router.wrappedValue.dismiss()
                
            }, label: {
                
                Text("IT'S ALL CLEAR!")
                    .foregroundColor(Color("primary"))
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color("bgGray")))
                    .padding()
            })
            .buttonStyle(ScaledButton(scaling: 0.9))
        }
    }
}

#Preview {
    RulesView(isForGame: true, isTopBar: true, playAction: {})
}
