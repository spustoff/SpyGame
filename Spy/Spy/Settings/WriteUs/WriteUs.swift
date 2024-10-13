//
//  WriteUs.swift
//  Spy
//
//  Created by Вячеслав on 12/30/23.
//

import SwiftUI

struct WriteUs: View {
    
    @Environment(\.presentationMode) var router
    
    let isPaddingTop: Bool
    
    @StateObject var viewModel = WriteUsViewModel()
    
    @State private var counterVibro = 0
    
    var body: some View {
        
        ZStack {
            
            Color.bgPrime.ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("Write to us")
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
                .padding([.horizontal, .top])
                .padding(.bottom, 2)
                .if(isPaddingTop, content: { view in
                
                    view
                        .padding(.top)
                })
//                .padding(.bottom, 9)
                
//                Text(NSLocalizedString("Share your opinion, what you would like to improve, it is very important for us", comment: ""))
//                    .font(.system(size: 17))
//                    .foregroundColor(.textWhite80)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack(spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            
                            Text("E-Mail")
                                .foregroundColor(.textWhite)
                                .font(.system(size: 19, weight: .bold))
                            
                            ZStack(alignment: .leading, content: {
                                
                                Text("Your e-mail")
                                    .foregroundColor(.textWhite40)
                                    .font(.system(size: 17, weight: .medium))
                                    .underline(false)
                                    .opacity(viewModel.email.isEmpty ? 1 : 0)
                                
                                TextField("", text: $viewModel.email)
                                    .foregroundColor(.textWhite)
                                    .font(.system(size: 17, weight: .medium))
                            })
                            .padding(.horizontal, 12)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                        })
                        
//                        VStack(alignment: .leading, spacing: 8, content: {
//                            
//                            Text("Subject")
//                                .foregroundColor(.textWhite)
//                                .font(.system(size: 19, weight: .bold))
//                            
//                            ZStack(alignment: .leading, content: {
//                                
//                                Text("Your subject")
//                                    .foregroundColor(.textWhite40)
//                                    .font(.system(size: 17, weight: .medium))
//                                    .underline(false)
//                                    .opacity(viewModel.subject.isEmpty ? 1 : 0)
//                                
//                                TextField("", text: $viewModel.subject)
//                                    .foregroundColor(.textWhite)
//                                    .font(.system(size: 17, weight: .medium))
//                            })
//                            .padding(.horizontal, 12)
//                            .frame(height: 60)
//                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
//                        })
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            
                            Text("Message")
                                .foregroundColor(.textWhite)
                                .font(.system(size: 19, weight: .bold))
                            
                            ZStack(alignment: .topLeading, content: {
                                
                                Text("Write your question or problem here")
                                    .foregroundColor(.textWhite40)
                                    .font(.system(size: 17, weight: .medium))
                                    .padding(.horizontal, 3)
                                    .opacity(viewModel.message.isEmpty ? 1 : 0)
                                
                                ResizableTextView(text: $viewModel.message, height: $viewModel.textViewHeight, isFirstResponder: .constant(false))
                                    .frame(height: viewModel.textViewHeight < 340 ? viewModel.textViewHeight : 340)
                            })
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                        })
                    }
                    .padding()
                }
                
                Spacer()
                
                let isDis = !viewModel.email.contains("@") || viewModel.subject.isEmpty || viewModel.message.isEmpty
                Button(action: {
                    counterVibro += 1
                    viewModel.sendEmail {
                        
                        router.wrappedValue.dismiss()
                    }
                    
                }, label: {
                    
                    ZStack {
                        
                        if viewModel.isLoading {
                            
                            Loader(width: 15, height: 15, color: .white)
                            
                        } else {
//                            PrimeButton(text: NSLocalizedString("SEND", comment: ""))
                            Text("SEND")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(isDis ? .textWhite40 : .textWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(LinearGradient(colors: [isDis ? .bgButtonDisabled : .primeTopTrailGrad , isDis ? .bgButtonDisabled : .primeBotLeadGrad], startPoint: .topTrailing, endPoint: .bottomLeading))
                                )
                        }
                    }
                    .padding()
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .opacity(isDis ? 0.5 : 1)
                .disabled(isDis ? true : false)
            }
            .sensoryFeedbackMod(trigger: $counterVibro)
        }
    }
}

#Preview {
    WriteUs(isPaddingTop: false)
}
