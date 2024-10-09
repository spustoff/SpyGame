//
//  VotingView.swift
//  Spy
//
//  Created by Вячеслав on 11/20/23.
//

import SwiftUI

struct VotingView: View {
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        
        ZStack {
            
//            Color.red
//                .ignoresSafeArea()
            
            ZStack {
                
                Color.black.opacity(viewModel.isVoting ? 0.5 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        
                        viewModel.closeVotingModal()
                    }
                
                VStack {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.4))
                        .frame(width: 50, height: 5)
                    
                    viewModel.getVotingSteps()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Rectangle().fill(Color("bg")).cornerRadius(radius: 25, corners: [.topLeft, .topRight]).ignoresSafeArea())
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: viewModel.isVoting ? 0 : UIScreen.main.bounds.height)
                .animation(.spring(), value: viewModel.currentVotingStep)
            }
        }
    }
}

#Preview {
    VotingView(viewModel: MainViewModel())
}
