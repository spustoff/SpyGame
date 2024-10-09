//
//  HistoryView.swift
//  Spy
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel = HistoryViewModel()
    
    @Environment(\.presentationMode) var router
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("History")
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
                
                if viewModel.history.isEmpty {
                    
                    VStack(alignment: .center, spacing: 15, content: {
                        
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(Color("bg"))
                            .font(.system(size: 18, weight: .medium))
                            .frame(width: 45, height: 45)
                            .background(Circle().fill(Color.gray.opacity(0.8)))
                        
                        VStack(alignment: .center, spacing: 2, content: {
                            
                            Text("History is empty")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .medium))
                                .multilineTextAlignment(.center)
                            
                            Text("You haven't played a game yet, start playing!")
                                .foregroundColor(.gray)
                                .font(.system(size: 14, weight: .regular))
                                .multilineTextAlignment(.center)
                        })
                    })
                    .padding()
                    .frame(maxHeight: .infinity, alignment: .center)
                    
                } else {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        LazyVStack {
                            
                            ForEach(viewModel.history, id: \.self) { index in
                            
                                NavigationLink(destination: {
                                    
                                    HistoryDetail(item: index)
                                        .navigationBarBackButtonHidden()
                                    
                                }, label: {
                                    
                                    HistoryRow(item: index)
                                })
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            
            viewModel.fetchHistory()
        }
    }
}

#Preview {
    HistoryView()
}
