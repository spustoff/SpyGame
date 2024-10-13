//
//  SettingsView.swift
//  Spy
//
//  Created by Вячеслав on 11/12/23.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = SettingsViewModel()
    @StateObject var paywallModel = PaywallViewModel()
    @StateObject var KCManager = KeychainDataStore()
    @StateObject var setsModel = MainSetsViewModel()
    
    @State var versionClicked = 0
    
    @Environment(\.presentationMode) var router
    
    var body: some View {
        
        ZStack {
            
            Color.bgPrime.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ZStack {
                    
                    Text("Settings")
                        .foregroundColor(.textWhite)
                        .font(.system(size: 19, weight: .bold))
                    
                    HStack {
                        
                        Button(action: {
                            
                            router.wrappedValue.dismiss()
                            
                        }, label: {
                            Icon(image: "chevron.left")
                        })
                        
                        Spacer()
                    }
                }
//                .padding(.top, 6)
                .padding(.horizontal)
                .padding(.bottom, 2)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack(spacing: 24) {
                        
                        if !viewModel.is_paidSubscription {
                            VStack(spacing: 8) {
                                Button(action: {
                                    
                                    viewModel.isPaywall = true
                                    
                                }, label: {
                                    
                                    VStack(alignment: .leading, spacing: -40, content: {
                                        
                                        VStack(alignment: .leading, spacing: 0, content: {
                                            
                                            Text("Premium Full Access")
                                                .foregroundColor(Color.prime)
                                                .font(.system(size: 13, weight: .medium))
                                            
                                            Text("Get Premium")
                                                .foregroundColor(Color.second)
                                                .font(.system(size: 24, weight: .bold))
                                            
                                            Text("Choose your plan")
                                                .foregroundColor(.textWhite60)
                                                .font(.system(size: 15, weight: .regular))
                                        })
//                                        .padding(.top, 6)
                                        .padding(.horizontal)
                                        
                                        Spacer()
                                        
                                        HStack(alignment: .bottom) {
                                            
                                            Text("TRY IT")
                                                .foregroundColor(.textWhite)
                                                .font(.system(size: 14, weight: .bold))
                                                .padding(.horizontal, 18)
                                                .frame(height: 48)
                                                .background(RoundedRectangle(cornerRadius: 16).fill(LinearGradient(colors: [Color.primeTopTrailGrad, Color.primeBotLeadGrad], startPoint: .topTrailing, endPoint: .bottomLeading)))
                                                .padding([.leading, .bottom])
                                            
                                            Spacer()
                                            
                                            Image("gift")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 130)
                                                .cornerRadius(radius: 15, corners: .allCorners)
                                        }
                                    })
                                    .frame(height: 190)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                                })
                                .buttonStyle(ScaledButton(scaling: 0.9))
                                
                                Button(action: {
                                    
                                    Task {
                                        await paywallModel.restorePurchases() {
                                            self.presentationMode.wrappedValue.dismiss()
//                                            subscribeCover.toggle()
                                        }
                                    }
//                                    paywallModel.restorePurchases()
                                    
                                }, label: {
                                    
                                    HStack {
                                        SettingsButton(icon: "crown", text: "Restore Purchases")
                                    }
                                })
                                .buttonStyle(ScaledButton(scaling: 0.9))
                            }
                        }
                        
                        VStack(spacing: 8) {
                            HStack {
                                Image("info.bubble")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                
                                Text("Show Rules")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17, weight: .regular))
                                
                                Spacer()
                                
                                Toggle(isOn: $viewModel.is_rules, label: {})
                                    .toggleStyle(SwitchToggleStyle(tint: Color.prime))
                                    .labelsHidden()
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                            
                            HStack {
                                
                                Image("speaker.wave.2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                
                                Text(NSLocalizedString("Sound", comment: ""))
                                    .foregroundColor(.textWhite)
                                    .font(.system(size: 17, weight: .regular))
                                
                                Spacer()
                                
                                Toggle(isOn: $viewModel.is_sound, label: {})
                                    .toggleStyle(SwitchToggleStyle(tint: Color.prime))
                                    .labelsHidden()
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                            
                            HStack {
                                
                                Image("iphone.radiowaves.left.and.right.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                
                                Text("Vibration")
                                    .foregroundColor(.textWhite)
                                    .font(.system(size: 17, weight: .regular))
                                
                                Spacer()
                                
                                Toggle(isOn: $viewModel.is_vibration, label: {})
                                    .toggleStyle(SwitchToggleStyle(tint: Color.prime))
                                    .labelsHidden()
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                            
                            Button(action: {
                                
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    
                                    UIApplication.shared.open(settingsURL)
                                }
                                
                            }, label: {
                                
                                HStack {
                                    SettingsButton(icon: "globeSet", text: "Language")
                                }
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                        }
                        
                        VStack(spacing: 8) {
                            NavigationLink(destination: {
                                
                                WriteUs(isPaddingTop: false)
                                    .navigationBarBackButtonHidden()
                                
                            }, label: {
                                
                                HStack {
                                    SettingsButton(icon: "envelope", text: "Write to us")
                                }
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                            
                            Button(action: {
                                
                                SKStoreReviewController.requestReview()
                                
                            }, label: {
                                
                                HStack {
                                    SettingsButton(icon: "star.square", text: "Rate our app")
                                }
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                            
                            Button(action: {
                                
                                viewModel.isShare = true
                                
                            }, label: {
                                
                                HStack {
                                    SettingsButton(icon: "square.and.arrow.up", text: "Share with friends")
                                }
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                            
                            Button(action: {
                                
                                guard let url = URL(string: "https://docs.google.com/document/d/1BvuGHqC5LIK7SjwiQvnHEyEtuaXFmF_4POkhj-km1zU/edit#heading=h.fi8181mpja0") else { return }
                                
                                UIApplication.shared.open(url)
                                
                            }, label: {
                                
                                HStack {
                                    SettingsButton(icon: "doc.text", text: NSLocalizedString("Usage policy", comment: ""))
                                }
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                            
                        }
                        
                        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            
                            Text("App Version: \(version)")
                                .foregroundColor(.gray)
                                .font(.system(size: 15, weight: .regular))
                                .onTapGesture() {
                                    
                                    if versionClicked >= 5 {
                                        
                                        KCManager.saveNumber(0, forKey: "subscriptionAvailableGames2")
                                        
                                        versionClicked = 0
                                        
                                    } else {
                                        
                                        versionClicked += 1
                                    }
                                }
                        }
                    }
                    .padding([.horizontal, .bottom])
                    .padding(.top, 14)
                }
            }
        }
        .sheet(isPresented: $viewModel.isPaywall, content: {
            
            PaywallView()
        })
        .sheet(isPresented: $viewModel.isShare) {
            
            if let url = URL(string: "https://apps.apple.com/us/app/spy/id6473184226") {
                
                ShareSheet(items: [url])
            }
        }
    }
}

#Preview {
    SettingsView()
}


struct SettingsButton: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(.second)
            Text(NSLocalizedString(text, comment: ""))
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.textWhite)
            Spacer()
            Image("chevron.right")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(.second)
                .colorScheme(.dark)
        }
        .padding(.horizontal, 12)
        .frame(height: 60)
        .background(Color.bgCell)
        .embedInCornRadius(cornradius: 12)
    }
}
