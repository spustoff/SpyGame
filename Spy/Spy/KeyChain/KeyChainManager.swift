//
//  KeyChainManager.swift
//  Spy
//
//  Created by Вячеслав on 12/28/23.
//

import SwiftUI

class KeychainManager {
    
    static let shared = KeychainManager()

    private init() {}

    func save(number: Int, for key: String) -> Bool {
        
        guard let data = String(number).data(using: .utf8) else { return false }

        let query = [
            
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
            
        ] as [String : Any]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }

    func loadNumber(for key: String) -> Int? {
        
        let query = [
            
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
            
        ] as [String : Any]

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data, let numberString = String(data: data, encoding: .utf8) {
            
            return Int(numberString)
        }
        
        return nil
    }

    func delete(for key: String) {
        
        let query = [
            
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
            
        ] as [String : Any]

        SecItemDelete(query as CFDictionary)
    }
}
