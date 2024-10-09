//
//  SettingsView.swift
//  Spy
//
//  Created by Вячеслав on 11/12/23.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    @StateObject var paywallModel = PaywallViewModel()
    @StateObject var KCManager = KeychainDataStore()
    @StateObject var setsModel = MainSetsViewModel()
    
    @State var versionClicked = 0
    
    @Environment(\.presentationMode) var router
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("Settings")
                        .foregroundColor(.white)
                        .font(.system(size: 21, weight: .semibold))
                    
                    HStack {
                        
                        Button(action: {
                            
                            router.wrappedValue.dismiss()
                            
                        }, label: {
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("bezhev"))
                                .font(.system(size: 21, weight: .semibold))
                        })
                        
                        Spacer()
                    }
                }
                .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack {
                        
                        if !viewModel.is_paidSubscription {
                            
                            Button(action: {
                                
                                viewModel.isPaywall = true
                                
                            }, label: {
                                
                                VStack(alignment: .leading, spacing: -40, content: {
                                    
                                    VStack(alignment: .leading, spacing: 5, content: {
                                        
                                        Text("Premium Full Access")
                                            .foregroundColor(Color("primary"))
                                            .font(.system(size: 12, weight: .medium))
                                        
                                        Text("Premium")
                                            .foregroundColor(Color("bezhev"))
                                            .font(.system(size: 23, weight: .semibold))
                                        
                                        Text("Choose your plan")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14, weight: .regular))
                                    })
                                    .padding([.horizontal, .top])
                                    
                                    HStack(alignment: .bottom) {
                                        
                                        Text("TRY IT")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .medium))
                                            .padding(.horizontal, 20)
                                            .frame(height: 45)
                                            .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                                            .padding([.leading, .bottom])
                                        
                                        Spacer()
                                        
                                        Image("gift")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 135, height: 135)
                                            .cornerRadius(radius: 15, corners: .allCorners)
                                    }
                                })
                                .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                        }
                        
                        Button(action: {
                            
                            paywallModel.restorePurchases()
                            
                        }, label: {
                            
                            HStack {
                                
                                Image("restore_purchases.icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 26, height: 26)
                                
                                Text("Restore Purchases")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .medium))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("bezhev").opacity(0.7))
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                            .padding(.bottom)
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        HStack {
                            
                            Image("rules.icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 26, height: 26)
                            
                            Text("Show Rules")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .medium))
                            
                            Spacer()
                            
                            Toggle(isOn: $viewModel.is_rules, label: {})
                                .toggleStyle(SwitchToggleStyle(tint: Color("primary")))
                        }
                        .padding(.horizontal)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                        
                        HStack {
                            
                            Image("vibration.icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 26, height: 26)
                            
                            Text("Vibration")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .medium))
                            
                            Spacer()
                            
                            Toggle(isOn: $viewModel.is_vibration, label: {})
                                .toggleStyle(SwitchToggleStyle(tint: Color("primary")))
                        }
                        .padding(.horizontal)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                        
                        Button(action: {
                            
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                
                                UIApplication.shared.open(settingsURL)
                            }
                            
                        }, label: {
                            
                            HStack {
                                
                                Image("language.icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 26, height: 26)
                                
                                Text("Language")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .medium))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("bezhev").opacity(0.7))
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                            .padding(.bottom)
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        NavigationLink(destination: {
                            
                            WriteUs(isPaddingTop: false)
                                .navigationBarBackButtonHidden()
                            
                        }, label: {
                            
                            HStack {
                                
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(Color("bezhev"))
                                    .frame(width: 26, height: 26)
                                
                                Text("Write to us")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .medium))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("bezhev").opacity(0.7))
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        Button(action: {
                            
                            SKStoreReviewController.requestReview()
                            
                        }, label: {
                            
                            HStack {
                                
                                Image("rate.icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 26, height: 26)
                                
                                Text("Rate our app")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .medium))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("bezhev").opacity(0.7))
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        Button(action: {
                            
                            viewModel.isShare = true
                            
                        }, label: {
                            
                            HStack {
                                
                                Image("share.icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 26, height: 26)
                                
                                Text("Share with friends")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .medium))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("bezhev").opacity(0.7))
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        Button(action: {
                            
                            guard let url = URL(string: "https://docs.google.com/document/d/1aY0TdyCzRU_0PNgs889y5-iezZdbvuE74nWyneg6PPM/edit?usp=sharing") else { return }
                            
                            UIApplication.shared.open(url)
                            
                        }, label: {
                            
                            HStack {
                                
                                Image("usage_policy.icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 26, height: 26)
                                
                                Text("Privacy Policy")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .medium))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("bezhev").opacity(0.7))
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        Button(action: {
                            
                            guard let url = URL(string: "https://docs.google.com/document/d/1BvuGHqC5LIK7SjwiQvnHEyEtuaXFmF_4POkhj-km1zU/edit#heading=h.fi8181mpja0") else { return }
                            
                            UIApplication.shared.open(url)
                            
                        }, label: {
                            
                            HStack {
                                
                                Image("usage_policy.icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 26, height: 26)
                                
                                Text("Terms of Use")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .medium))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("bezhev").opacity(0.7))
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        Button(action: {
                            
                            viewModel.isResetSets = true
                            
                        }, label: {
                            
                            HStack {
                                
                                Image("reset.icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 26, height: 26)
                                
                                Text("Reset Default Sets")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .medium))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("bezhev").opacity(0.7))
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            
                            Text("App Version: \(version)")
                                .foregroundColor(.gray)
                                .font(.system(size: 13, weight: .regular))
                                .padding(.top, 20)
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
                }
            }
        }
        .alert(isPresented: $viewModel.isResetSets) {
            
            Alert(
                title: Text("Reset the default sets?"),
                message: Text("Only your sets will be reset, our sets will be saved. You'll have to re-enter the game"),
                primaryButton: .destructive(Text("Reset")) {
                    
                    CoreDataStack.shared.deleteAllSets()
                    setsModel.fetchSets()
                },
                secondaryButton: .cancel()
            )
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
