//
//  SplashView.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject var viewModel = SplashViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                TabView(selection: $viewModel.current_splash, content: {
                    
                    ForEach(viewModel.splash_screens, id: \.id) { index in
                        
                        VStack(spacing: 0) {
                            
                            let currentLanguageCode = Locale.current.languageCode ?? "en"
                            
                            Image("\(index.image)_\(currentLanguageCode)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            VStack(spacing: 10, content: {
                                
                                Text(NSLocalizedString(index.hint, comment: ""))
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 14, weight: .regular))
                                    .padding(.horizontal, 10)
                                    .frame(height: 30)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(Color("bgGray")))
                                
                                Text(NSLocalizedString(index.title, comment: ""))
                                    .foregroundColor(.white)
                                    .font(.system(size: 26, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                
                                Text(NSLocalizedString(index.subtitle, comment: ""))
                                    .foregroundColor(.white.opacity(0.6))
                                    .font(.system(size: 18, weight: .regular))
                                    .multilineTextAlignment(.center)
                            })
                            .padding()
                            
                            Spacer()
                        }
                        .ignoresSafeArea(.all, edges: .top)
                    }
                })
                .ignoresSafeArea(.all, edges: .top)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(alignment: .center, spacing: 6, content: {
                    
                    HStack {
                        
                        ForEach(0..<viewModel.splash_screens.count, id: \.self) { index in
                            
                            Circle()
                                .fill(viewModel.current_splash > index ? Color("primary") : .gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Button(action: {
                        
                        if viewModel.current_splash == viewModel.splash_screens.count {
                            
                            viewModel.status = true
                            
                        } else {
                            
                            viewModel.manageControl()
                        }
                        
                    }, label: {
                        
                        Text("NEXT")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("primary")))
                            .padding()
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                })
            }
        }
    }
}

#Preview {
    SplashView()
}
