//
//  Ext+ConvertDate.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

extension Date {
    
    func convertDate(format: String) -> String {
        
        let date = self
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
}
