//
//  Ext+EndEditing.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
