//
//  PaywallView.swift
//  Spy
//
//  Created by Вячеслав on 12/1/23.
//

import SwiftUI

struct PaywallView: View {
    
    @StateObject var viewModel = PaywallViewModel()
    
    @Environment(\.presentationMode) var router
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            Image("paywall_bg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
         
            VStack {
                
                HStack {
                    
                    Button(action: {
                        
                        router.wrappedValue.dismiss()
                        
                    }, label: {
                        
                        Image(systemName: "xmark")
                            .foregroundColor(Color("primary"))
                            .font(.system(size: 21, weight: .semibold))
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                        viewModel.restorePurchases()
                        
                    }, label: {
                        
                        Text("RESTORE")
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .medium))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .disabled(viewModel.isPurchasing || viewModel.isLoading ? true : false)
                }
                .padding()
                .padding(.top)
                
                Image("logo_big")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 233, height: 233)
                    .padding(.bottom)
                
                VStack(alignment: .center, spacing: 15, content: {
                    
                    Text("Premium Full Access")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .semibold))
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 10, content: {
                        
                        ForEach(["Full access to all content", "Regular content updates"], id: \.self) { index in
                            
                            HStack(alignment: .center, spacing: 6, content: {
                                
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 18, weight: .regular))
                                
                                Text(NSLocalizedString(index, comment: ""))
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 16, weight: .regular))
                            })
                        }
                    })
                })
                
                Spacer()
                
                if viewModel.isLoading {
                    
                    Loader(width: 30, height: 30, color: .white)
                        .frame(maxHeight: .infinity, alignment: .center)
                    
                } else {
                    
                    HStack {
                        
                        ForEach(viewModel.products, id: \.self) { index in
                            
                            Button(action: {
                                
                                withAnimation(.spring()) {
                                    
                                    viewModel.selected_product = index
                                }
                                
                            }, label: {
                                
                                VStack(spacing: 30) {
                                    
                                    if let skProduct = index.skProduct {
                                        
                                        Text(viewModel.formattedSubscriptionPeriod(for: skProduct))
                                            .foregroundColor(.white)
                                            .font(.system(size: 14, weight: .regular))
                                            .multilineTextAlignment(.center)
                                        
                                        VStack(alignment: .center, spacing: 3, content: {
                                            
                                            Text(viewModel.formattedPrice(for: skProduct))
                                                .foregroundColor(.white)
                                                .font(.system(size: 19, weight: .semibold))
                                                .multilineTextAlignment(.center)
                                            
                                            Text("\(viewModel.formattedPrice(for: index.skProduct!))/\(viewModel.formattedSubscriptionPeriod(for: skProduct))")
                                                .foregroundColor(.white.opacity(0.5))
                                                .font(.system(size: 11, weight: .regular))
                                                .multilineTextAlignment(.center)
                                        })
                                        
                                    } else {
                                        
                                        VStack(alignment: .center, spacing: 2, content: {
                                            
                                            Text("$0.00")
                                                .foregroundColor(.white)
                                                .font(.system(size: 19, weight: .semibold))
                                                .multilineTextAlignment(.center)
                                            
                                            Text("$0.00/week")
                                                .foregroundColor(.white.opacity(0.5))
                                                .font(.system(size: 11, weight: .regular))
                                                .multilineTextAlignment(.center)
                                        })
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.2)))
                                .overlay(
                                
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color("primary"), lineWidth: 2)
                                        .opacity(viewModel.selected_product == index ? 1 : 0)
                                )
                                .overlay(
                                
                                    HStack {
                                        
                                        Text("Popular")
                                            .foregroundColor(.white)
                                            .font(.system(size: 11, weight: .regular))
                                    }
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("primary")))
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .offset(y: -12)
                                        .opacity((index.skProduct?.productIdentifier ?? "").contains("year") ? 1 : 0)
                                )
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                            .disabled(viewModel.isPurchasing || viewModel.isLoading ? true : false)
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
                
                VStack(alignment: .center, spacing: 20, content: {
                    
                    Button(action: {
                        
                        viewModel.purchaseProduct()
                        
                    }, label: {
                        
                        ZStack {
                            
                            if viewModel.isPurchasing {
                                
                                Loader(width: 15, height: 15, color: .white)
                                
                            } else {
                                
                                Text("TRY IT")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                        .padding(.horizontal)
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .opacity(viewModel.selected_product == nil ? 0.5 : 1)
                    .disabled(viewModel.selected_product == nil || viewModel.isPurchasing ? true : false)
                    
                    HStack {
                        
                        Button(action: {
                            
                            guard let url = URL(string: "https://docs.google.com/document/d/1aY0TdyCzRU_0PNgs889y5-iezZdbvuE74nWyneg6PPM/edit?usp=sharing") else { return }
                            
                            UIApplication.shared.open(url)
                            
                        }, label: {
                            
                            Text("Privacy Policy")
                                .foregroundColor(.gray)
                                .font(.system(size: 11, weight: .regular))
                                .multilineTextAlignment(.leading)
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        HStack {
                            

                        }
                        .opacity(0.001)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Button(action: {
                            
                            guard let url = URL(string: "https://docs.google.com/document/d/1BvuGHqC5LIK7SjwiQvnHEyEtuaXFmF_4POkhj-km1zU/edit#heading=h.fi8181mpja0") else { return }
                            
                            UIApplication.shared.open(url)
                            
                        }, label: {
                            
                            Text("Term of Use")
                                .foregroundColor(.gray)
                                .font(.system(size: 11, weight: .regular))
                                .multilineTextAlignment(.trailing)
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                    }
                    .padding(.horizontal, 25)
                })
            }
        }
        .onAppear {
            
            viewModel.getPaywalls()
        }
    }
}

#Preview {
    PaywallView()
}
