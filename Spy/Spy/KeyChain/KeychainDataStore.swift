//
//  KeychainDataStore.swift
//  Spy
//
//  Created by Вячеслав on 12/28/23.
//

import SwiftUI

class KeychainDataStore: ObservableObject {
    
    @Published var savedNumber: Int = 0
    
    @Published var availableGames: Int = 3

    func saveNumber(_ number: Int, forKey key: String) {
        
        let saved = KeychainManager.shared.save(number: number, for: key)
        
        if saved {
            
            self.savedNumber = number
        }
    }

    func loadNumber(forKey key: String) -> Int {
        
        if let loadedNumber = KeychainManager.shared.loadNumber(for: key) {
            
            savedNumber = loadedNumber
            
            return loadedNumber
        }
        
        return 0
    }

    func deleteNumber(forKey key: String) {
        
        KeychainManager.shared.delete(for: key)
        
        savedNumber = 0
    }
}

