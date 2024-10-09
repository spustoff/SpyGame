//
//  ContentView.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("status") var status: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            if status == true {
                
                MainView(viewModel: MainViewModel())
                
            } else if status == false {
                
                SplashView()
            }
        }
    }
}

#Preview {
    ContentView()
}
