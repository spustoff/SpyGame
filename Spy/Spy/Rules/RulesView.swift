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
    
    @State private var counterVibro = 0
    
    var body: some View {
        
        ZStack {
            
            if isTopBar {
                
                Color.bgPrime.ignoresSafeArea()
            }
            
            VStack {
                
                if isTopBar {
                    
                    ZStack {
                        
                        Text("Rules")
                            .foregroundColor(.white)
                            .font(.system(size: 19, weight: .bold))
                        
                        HStack {
                            
                            Button(action: {
                                
                                router.wrappedValue.dismiss()
                                
                            }, label: {
                                Image("chevron.left")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.second)
//                                Image(systemName: isForGame ? "xmark" : "chevron.left")
//                                    .foregroundColor(Color(isForGame ? "primary" : "bezhev"))
//                                    .font(.system(size: 21, weight: .semibold))
                            })
                            
                            Spacer()
                        }
                    }
                    .padding([.horizontal, .top])
                    .padding(.bottom, 2)
                    .padding(.top, isForGame ? 16 : 0)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack(spacing: 24) {
                        
                        ForEach(viewModel.rule_screens, id: \.id) { indexer in
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                
                                Text(NSLocalizedString(indexer.mainPoint, comment: ""))
                                    .foregroundColor(.white)
                                    .font(.system(size: 19, weight: .bold))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                    
                                    ForEach(indexer.subPoints, id: \.id) { index in
                                        
                                        Button(action: {
                                            counterVibro += 1
                                            viewModel.current_rule = index.identifier
                                            viewModel.isDetail = true
                                            
                                        }, label: {
                                            
                                            VStack(alignment: .leading, spacing: 1, content: {
                                                
                                                Text("\(index.id) \(NSLocalizedString(index.title, comment: ""))")
                                                    .foregroundColor(.textWhite)
                                                    .font(.system(size: 17, weight: .medium))
                                                    .padding(.top, 16)
                                                    .padding(.leading, 12)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Spacer()
                                                
                                                HStack(alignment: .bottom) {
                                                    
                                                    Image("\(index.id)")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 112, height: 112)
                                                        .cornerRadius(10)
                                                    
                                                    Spacer()
                                                    
                                                    Image("chevron.right")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 32, height: 32)
                                                        .foregroundColor(.second)
                                                        .colorScheme(.dark)
                                                        .padding(.bottom, 16)
                                                        .padding(.trailing, 12)
                                                }
                                            })
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                                        })
                                        .buttonStyle(ScaledButton(scaling: 0.9))
                                    }
                                }
                                .padding([.horizontal, .bottom])
                            })
                        }
                    }
                    .padding(.top, 14)
                }
                .edgesIgnoringSafeArea(.bottom)
                .sensoryFeedbackMod(trigger: $counterVibro)
                
//                Spacer()
                
//                bottomTab()
            }
        }
        .background(Color.bgPrime)
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
                PrimeButton(text: NSLocalizedString("START THE GAME", comment: ""))
            })
            .padding()
            .buttonStyle(ScaledButton(scaling: 0.9))
            
        } else {
            
            Button(action: {
                
                router.wrappedValue.dismiss()
                
            }, label: {
                PrimeButton(text: NSLocalizedString("IT'S ALL CLEAR!", comment: ""))
            })
            .padding()
            .buttonStyle(ScaledButton(scaling: 0.9))
        }
    }
}

#Preview {
    RulesView(isForGame: true, isTopBar: true, playAction: {})
}
