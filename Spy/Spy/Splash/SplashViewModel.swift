//
//  SplashViewModel.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI
import Combine
import StoreKit

final class SplashViewModel: ObservableObject {
    
    @AppStorage("status") var status: Bool = false
    
    private var reviewScreenListener = Set<AnyCancellable>()
    
    @Published var current_splash: Int = 1
    @Published var splash_screens: [SplashModel] = [
    
        SplashModel(id: 1, hint: "Lots of game options", title: "Intrigues and Secrets", subtitle: "This is a fascinating game where everyone can become a master of deception", image: "splash_1"),
        SplashModel(id: 2, hint: "Interesting sets", title: "Locations await you", subtitle: "Choose a set that suits you and play the game in a new way", image: "splash_2"),
        SplashModel(id: 3, hint: "Party Game", title: "Perfect for friends", subtitle: "Use your logical and analytical skills to win this game", image: "splash_3"),
        SplashModel(id: 4, hint: "Please", title: "Rate us in the AppStore", subtitle: "Help make our game even better", image: "splash_4"),
    ]

    init() {
        
        $current_splash
            .sink { [weak self] url in
                
                guard let self = self else { return }
                
                if url == self.splash_screens.count {
                    
                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }
            }
            .store(in: &reviewScreenListener)
    }
    
    public func manageControl() {
        
        if current_splash != splash_screens.count {
            
            withAnimation(.spring()) {
                
                self.current_splash += 1
            }
            
        } else {
            
            withAnimation(.spring()) {
                
                self.status = true
            }
        }
    }
}
