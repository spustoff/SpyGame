//
//  Ext+UserDefaults.swift
//  Spy
//
//  Created by Вячеслав on 11/26/23.
//

import SwiftUI

extension UserDefaults {
    
    func setDictionary(_ value: [String: String], forKey key: String) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: value, options: [])
        
        set(jsonData, forKey: key)
    }

    func dictionary(forKey key: String) -> [String: String]? {
        
        guard let jsonData = data(forKey: key) else { return nil }
        
        return (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? [String: String]
    }
}
