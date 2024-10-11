//
//  ContentView.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("status") var status: Bool = false
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            if status == true {
                
                MainView()
                    .environmentObject(viewModel)
                
            } else if status == false {
                
                SplashView()
            }
        }
    }
}

#Preview {
    ContentView()
}
