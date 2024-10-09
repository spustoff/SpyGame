//
//  Ext+TimeString.swift
//  Spy
//
//  Created by Вячеслав on 11/26/23.
//

import SwiftUI

func timeString(time: Int) -> String {
    
    let minutes = time / 60
    let seconds = time % 60
    
    return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
}
