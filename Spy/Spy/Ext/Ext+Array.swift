//
//  Ext+Array.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

extension Array {
    
    func element(at index: Int) -> Element? {
        
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array: RawRepresentable where Element: Codable {
    
    public init?(rawValue: String) {
        
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
                
        else {
            
            return nil
        }
        
        self = result
    }

    public var rawValue: String {
        
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
                
        else {
            
            return "[]"
        }
        
        return result
    }
}

extension Dictionary where Key: Codable, Value: Codable {
    
    func jsonData() -> Data? {
        
        try? JSONEncoder().encode(self)
    }

    static func from(jsonData: Data) -> [Key: Value]? {
        
        try? JSONDecoder().decode([Key: Value].self, from: jsonData)
    }
}
