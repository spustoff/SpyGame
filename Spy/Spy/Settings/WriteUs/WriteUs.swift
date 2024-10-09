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
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("Write to us")
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
                .if(isPaddingTop, content: { view in
                
                    view
                        .padding(.top)
                })
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack(spacing: 30) {
                        
                        VStack(alignment: .leading, spacing: 10, content: {
                            
                            Text("E-Mail")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                            
                            ZStack(alignment: .leading, content: {
                                
                                Text("Your e-mail")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .regular))
                                    .underline(false)
                                    .opacity(viewModel.email.isEmpty ? 1 : 0)
                                
                                TextField("", text: $viewModel.email)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .regular))
                            })
                            .padding()
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("bgGray")))
                        })
                        
                        VStack(alignment: .leading, spacing: 10, content: {
                            
                            Text("Subject")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                            
                            ZStack(alignment: .leading, content: {
                                
                                Text("Your subject")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .regular))
                                    .underline(false)
                                    .opacity(viewModel.subject.isEmpty ? 1 : 0)
                                
                                TextField("", text: $viewModel.subject)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .regular))
                            })
                            .padding()
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("bgGray")))
                        })
                        
                        VStack(alignment: .leading, spacing: 10, content: {
                            
                            Text("Message")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                            
                            ZStack(alignment: .leading, content: {
                                
                                Text("Write your question or problem here")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .regular))
                                    .padding(.horizontal, 3)
                                    .opacity(viewModel.message.isEmpty ? 1 : 0)
                                
                                ResizableTextView(text: $viewModel.message, height: $viewModel.textViewHeight, isFirstResponder: .constant(false))
                                    .frame(height: viewModel.textViewHeight < 340 ? viewModel.textViewHeight : 340)
                            })
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("bgGray")))
                        })
                    }
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    
                    viewModel.sendEmail {
                        
                        router.wrappedValue.dismiss()
                    }
                    
                }, label: {
                    
                    ZStack {
                        
                        if viewModel.isLoading {
                            
                            Loader(width: 15, height: 15, color: .white)
                            
                        } else {
                            
                            Text("SEND")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                    .padding()
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .opacity(!viewModel.email.contains("@") || viewModel.subject.isEmpty || viewModel.message.isEmpty ? 0.5 : 1)
                .disabled(!viewModel.email.contains("@") || viewModel.subject.isEmpty || viewModel.message.isEmpty ? true : false)
            }
        }
    }
}

#Preview {
    WriteUs(isPaddingTop: false)
}
