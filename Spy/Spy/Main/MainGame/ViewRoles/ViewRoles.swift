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
    
    @State private var counterVibro: Int = 0
    
    var body: some View {
        
        ZStack {
            
            Color.bgPrime
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
//                    Text(NSLocalizedString("Handing out", comment: ""))
//                        .foregroundColor(.textWhite)
//                        .font(.system(size: 19, weight: .bold))

                    Text("View Roles")
                        .foregroundColor(.white)
                        .font(.system(size: 19, weight: .bold))
                    
                    HStack {
                        
                        Button(action: {
                            counterVibro += 1
                            router.wrappedValue.dismiss()
                            
                        }, label: {
                            Icon(image: "xmark")
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
            .sensoryFeedbackMod(trigger: $counterVibro)
        }
    }
}

#Preview {
    ViewRoles(viewModel: MainViewModel())
}
