//
//  ReviewView.swift
//  Spy
//
//  Created by Вячеслав on 1/3/24.
//

import SwiftUI

struct ReviewView: View {
    
    @Environment(\.presentationMode) var router
    
    @StateObject var viewModel = ReviewViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.4))
                    .frame(width: 50, height: 5)
                    .padding(.top, 10)
                
                HStack {
                    
                    Button(action: {
                        
                        router.wrappedValue.dismiss()
                        
                    }, label: {
                        
                        Image(systemName: "xmark")
                            .foregroundColor(Color("primary"))
                            .font(.system(size: 21, weight: .semibold))
                    })
                    
                    Spacer()
                }
                .padding()
                
                Image("review\(viewModel.selected_stars >= 1 ? viewModel.isGoodRate() ? "_good" : "_bad" : "")")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .padding(.bottom)
                
                VStack(alignment: .center, spacing: 10, content: {
                    
                    Text("Your opinion")
                        .foregroundColor(Color("primary"))
                        .font(.system(size: 14, weight: .regular))
                        .padding(.horizontal, 10)
                        .frame(height: 30)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color("bgGray")))
                    
                    Text(viewModel.selected_stars >= 1 ? viewModel.isGoodRate() ? "Thanks for your feedback!" : "We'll work on it" : "Do you like the app?")
                        .foregroundColor(.white)
                        .font(.system(size: 26, weight: .semibold))
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.selected_stars >= 1 ? viewModel.isGoodRate() ? "You can also help us by rating in the AppStore" : "Write more details to our mail what you would like to improve or fix" : "Your feedback is very important to improve the app and make it better for you")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 18, weight: .regular))
                        .multilineTextAlignment(.center)
                })
                .padding()
                .padding(.bottom)
                
                HStack {
                    
                    ForEach(1...viewModel.total_stars, id: \.self) { index in
                    
                        Button(action: {
                            
                            viewModel.selected_stars = index
                            
                        }, label: {
                            
                            Image(systemName: viewModel.selected_stars >= index ? "star.fill" : "star.fill")
                                .foregroundColor(viewModel.selected_stars >= index ? Color("bezhev") : Color("bgGray"))
                                .font(.system(size: 35, weight: .regular))
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        .disabled(viewModel.isShowButton ? true : false)
                    }
                }
                
                Spacer()
                
                if viewModel.isShowButton {
                    
                    Button(action: {
                        
                        if viewModel.isGoodRate() {
                            
                            // MARK: -- WRITE REVIEW ON APP STORE
                            
                            router.wrappedValue.dismiss()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                
                                let appID = "6474504507"
                                guard let url = URL(string: "https://itunes.apple.com/app/id\(appID)?action=write-review") else { return }
                                
                                UIApplication.shared.open(url)
                            }
                            
                        } else {
                            
                            // MARK: -- WRITE E-MAIL
                            
                            viewModel.isOpenEmail = true
                        }
                        
                    }, label: {
                        
                        Text(viewModel.isGoodRate() ? "WRITE REVIEW" : "WRITE AN E-MAIL")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                            .padding()
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .modifier(AnimatedScale())
                }
            }
        }
        .sheet(isPresented: $viewModel.isOpenEmail, content: {
            
            WriteUs(isPaddingTop: true)
        })
        .onChange(of: viewModel.selected_stars) { star in
            
            viewModel.last_selectedStar = star
            
            viewModel.resetTimer()
        }
        .onDisappear {
            
            viewModel.isReviewedAlready = true
        }
    }
}

#Preview {
    ReviewView()
}
