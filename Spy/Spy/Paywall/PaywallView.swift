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
            
            Color.bgPrime.ignoresSafeArea()
            
            Image("paywallBG")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
         
            VStack {
                
                HStack {
                    
                    Button(action: {
                        
                        router.wrappedValue.dismiss()
                        
                    }, label: {
                        Icon(image: "xmark")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                        viewModel.restorePurchases()
                        
                    }, label: {
                        
                        Text("RESTORE")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .disabled(viewModel.isPurchasing || viewModel.isLoading ? true : false)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                Spacer()
            }
            
            VStack {
                Image("paywallSpy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .frame(maxWidth: 232, height: 232)
                    .padding(.horizontal, 67)
                    .padding(.top, 18)
                
                VStack(alignment: .center, spacing: 15, content: {
                    
                    Text("Premium Full Access")
                        .foregroundColor(.textWhite)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 10, content: {
                        
                        ForEach(["Full access to all content", "Regular content updates", NSLocalizedString("Creating your own sets", comment: "")], id: \.self) { index in
                            
                            HStack(alignment: .center, spacing: 6, content: {
                                
                                Icon(image: "checkmark")
                                
                                Text(NSLocalizedString(index, comment: ""))
                                    .foregroundColor(.textWhite80)
                                    .font(.system(size: 17, weight: .regular))
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
                                
                                ZStack {
                                    
                                    if let skProduct = index.skProduct {
                                        
                                        Text(viewModel.formattedSubscriptionPeriod(for: skProduct))
                                            .foregroundColor(.textWhite)
                                            .font(.system(size: 13, weight: .medium))
                                            .multilineTextAlignment(.center)
                                            .frame(maxHeight: .infinity, alignment: .top)
                                        
                                        VStack(alignment: .center, spacing: 4) {
                                            Text(viewModel.formattedPrice(for: skProduct))
                                                .foregroundColor(.textWhite)
                                                .font(.system(size: 17, weight: .medium))
                                                .multilineTextAlignment(.center)
                                            
                                            Text("\(viewModel.formattedPrice(for: index.skProduct!))/\(viewModel.formattedSubscriptionPeriod(for: skProduct))")
                                                .foregroundColor(.textWhite60)
                                                .font(.system(size: 11, weight: .regular))
                                                .multilineTextAlignment(.center)
                                        }
                                        
                                    } else {
                                        
                                        VStack(alignment: .center, spacing: 4, content: {
                                            
                                            Text("$0.00")
                                                .foregroundColor(.textWhite)
                                                .font(.system(size: 17, weight: .medium))
                                                .multilineTextAlignment(.center)
                                            
                                            Text("$0.00/week")
                                                .foregroundColor(.textWhite60)
                                                .font(.system(size: 11, weight: .regular))
                                                .multilineTextAlignment(.center)
                                        })
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 16)
                                .frame(height: 135)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                                .overlay(
                                
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.prime, lineWidth: 2)
                                        .opacity(viewModel.selected_product == index ? 1 : 0)
                                )
                                .overlay(
                                
                                    HStack {
                                        
                                        Text("Popular")
                                            .foregroundColor(.textWhite)
                                            .font(.system(size: 11, weight: .regular))
                                    }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.prime))
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
                                PrimeButton(text: NSLocalizedString("CONTINUE", comment: ""))
//                                Text("TRY IT")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 50)
//                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
//                        .padding(.horizontal)
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                    .opacity(viewModel.selected_product == nil ? 0.5 : 1)
                    .disabled(viewModel.selected_product == nil || viewModel.isPurchasing ? true : false)
                    .padding(.horizontal)
                    
                    HStack {
                        
                        Button(action: {
                            
                            guard let url = URL(string: "https://docs.google.com/document/d/1aY0TdyCzRU_0PNgs889y5-iezZdbvuE74nWyneg6PPM/edit?usp=sharing") else { return }
                            
                            UIApplication.shared.open(url)
                            
                        }, label: {
                            
                            Text("Privacy Policy")
                                .foregroundColor(.textWhite60)
                                .font(.system(size: 11, weight: .regular))
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.8)
                                .lineLimit(2)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                        
                        HStack {
                            Image(systemName: "lock")
                            Text(NSLocalizedString("Cancel anytime", comment: ""))
                        }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textWhite60)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Button(action: {
                            
                            guard let url = URL(string: "https://docs.google.com/document/d/1BvuGHqC5LIK7SjwiQvnHEyEtuaXFmF_4POkhj-km1zU/edit#heading=h.fi8181mpja0") else { return }
                            
                            UIApplication.shared.open(url)
                            
                        }, label: {
                            
                            Text("Term of Use")
                                .foregroundColor(.textWhite60)
                                .font(.system(size: 11, weight: .regular))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity)
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
