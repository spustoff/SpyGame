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
            
            Color.bgPrime.ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(.textWhite40)
                    .frame(width: 50, height: 4)
                    .padding(.top, 10)
                
                
                
                Image("review\(viewModel.selected_stars >= 1 ? viewModel.isGoodRate() ? "_good" : "_bad" : "")")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 248, height: 248)
                    .padding(.bottom)
                
                VStack(alignment: .center, spacing: 8, content: {
                    
//                    Text("Your opinion")
//                        .foregroundColor(Color("primary"))
//                        .font(.system(size: 14, weight: .regular))
//                        .padding(.horizontal, 10)
//                        .frame(height: 30)
//                        .background(RoundedRectangle(cornerRadius: 8).fill(Color("bgGray")))
                    
                    Text(viewModel.selected_stars >= 1 ? viewModel.isGoodRate() ? "Thanks for your feedback!" : "We'll work on it" : "Do you like the app?")
                        .foregroundColor(.textWhite)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.selected_stars >= 1 ? viewModel.isGoodRate() ? "You can also help us by rating in the AppStore" : "Write more details to our mail what you would like to improve or fix" : "Your feedback is very important to improve the app and make it better for you")
                        .foregroundColor(.textWhite80)
                        .font(.system(size: 17, weight: .regular))
                        .multilineTextAlignment(.center)
                })
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Button {
                        // MARK: -- WRITE REVIEW ON APP STORE
                        
                        router.wrappedValue.dismiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            
                            let appID = "6474504507"
                            guard let url = URL(string: "https://itunes.apple.com/app/id\(appID)?action=write-review") else { return }
                            
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text(NSLocalizedString("YES, I LIKE IT!", comment: ""))
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.textWhite)
                            .padding(.horizontal, 18)
                            .frame(height: 60)
                            .background(
                                LinearGradient(colors: [Color.primeTopTrailGrad, Color.primeBotLeadGrad], startPoint: .topTrailing, endPoint: .bottomLeading)
                            )
                            .embedInCornRadius(cornradius: 16)
                    }
                    
                    Button {
                        // MARK: -- WRITE E-MAIL
                        
                        viewModel.isOpenEmail = true
                    } label: {
                        Text("NO, I DON'T")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.prime)
                            .padding(.horizontal, 18)
                            .frame(height: 60)
                            .background(
                                Color.bgButton
                            )
                            .embedInCornRadius(cornradius: 16)
                    }
                }
                
//                HStack {
//                    
//                    ForEach(1...viewModel.total_stars, id: \.self) { index in
//                    
//                        Button(action: {
//                            
//                            viewModel.selected_stars = index
//                            
//                        }, label: {
//                            
//                            Image(systemName: viewModel.selected_stars >= index ? "star.fill" : "star.fill")
//                                .foregroundColor(viewModel.selected_stars >= index ? Color("bezhev") : Color("bgGray"))
//                                .font(.system(size: 35, weight: .regular))
//                        })
//                        .buttonStyle(ScaledButton(scaling: 0.9))
//                        .disabled(viewModel.isShowButton ? true : false)
//                    }
//                }
                
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
            
            VStack {
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
                .padding()
                Spacer()
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
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        ReviewView()
    }
}
