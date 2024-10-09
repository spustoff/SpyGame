//
//  ViewRoles.swift
//  Spy
//
//  Created by Вячеслав on 11/20/23.
//

import SwiftUI

struct ViewRoles: View {
    
    @StateObject var viewModel: MainViewModel
    
    @Environment(\.presentationMode) var router
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("View Roles")
                        .foregroundColor(.white)
                        .font(.system(size: 21, weight: .semibold))
                    
                    HStack {
                        
                        Button(action: {
                            
                            router.wrappedValue.dismiss()
                            
                        }, label: {
                            
                            Image(systemName: "xmark")
                                .foregroundColor(Color("bezhev"))
                                .font(.system(size: 21, weight: .semibold))
                        })
                        
                        Spacer()
                    }
                }
                .padding()
                .padding(.vertical)
                
                Spacer()
                
                CardsView(isPlayButton: false, viewModel: viewModel)
            }
            .onDisappear {
                
                viewModel.isActiveTimer = true
            }
        }
    }
}

#Preview {
    ViewRoles(viewModel: MainViewModel())
}
