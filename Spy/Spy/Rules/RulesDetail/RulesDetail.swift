//
//  RulesDetail.swift
//  Spy
//
//  Created by Вячеслав on 12/28/23.
//

import SwiftUI

struct RulesDetail: View {
    
    @Environment(\.presentationMode) var router
    
    @StateObject var viewModel: RulesViewModel
    
    var body: some View {
        
        ZStack {
            
            Color.bgPrime.ignoresSafeArea()
            
            TabView(selection: $viewModel.current_rule, content: {
                
                ForEach(viewModel.getPoints(), id: \.identifier) { index in
                
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        LazyVStack {
                            
                            let currentLanguageCode = Locale.current.languageCode ?? "en"
                            
                            Image("\(index.id)_rule_\(currentLanguageCode)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .padding(.top)
                        .padding(.top, 2)
                    }
//                    .padding(.top, 12)
                }
            })
            .edgesIgnoringSafeArea(.bottom)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                
                ZStack {
                    
                    Text(NSLocalizedString(viewModel.getPoints().first(where: {$0.identifier == viewModel.current_rule})?.title ?? "nil", comment: ""))
                        .foregroundColor(.textWhite)
                        .font(.system(size: 19, weight: .bold))
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            
                            router.wrappedValue.dismiss()
                            
                        }, label: {
                            Image("xmark")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color.second)
                        })
                    }
                }
                .padding([.horizontal, .top])
                .padding(.bottom, 6)
                .padding(.top)
                .background(Color.bgPrime.ignoresSafeArea())
                
                Spacer()
                
//                HStack {
//                    
//                    Button(action: {
//                        
//                        if viewModel.current_rule > 1 {
//                            
//                            viewModel.current_rule -= 1
//                            
//                        } else {
//                            
//                            viewModel.current_rule = viewModel.getPoints().count
//                        }
//                        
//                    }, label: {
//                        
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(Color("bezhev"))
//                            .font(.system(size: 19, weight: .semibold))
//                    })
//                    .buttonStyle(ScaledButton(scaling: 0.9))
//                    
//                    HStack {
//                        
//                        ForEach(viewModel.getPoints(), id: \.id) { index in
//                        
//                            Circle()
//                                .fill(viewModel.current_rule == index.identifier ? Color("primary") : Color("bgGray"))
//                                .frame(width: 8, height: 8)
//                                .animation(.easeInOut, value: viewModel.current_rule)
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                    
//                    Button(action: {
//                        
//                        if viewModel.current_rule < viewModel.getPoints().count {
//                            
//                            viewModel.current_rule += 1
//                            
//                        } else {
//                            
//                            viewModel.current_rule = 1
//                        }
//                        
//                    }, label: {
//                        
//                        Image(systemName: "arrow.right")
//                            .foregroundColor(Color("bezhev"))
//                            .font(.system(size: 19, weight: .semibold))
//                    })
//                    .buttonStyle(ScaledButton(scaling: 0.9))
//                }
//                .padding()
//                .padding([.horizontal, .bottom])
//                .background(Color.bgPrime.ignoresSafeArea())
            }
        }
    }
}

#Preview {
    RulesDetail(viewModel: RulesViewModel())
}
