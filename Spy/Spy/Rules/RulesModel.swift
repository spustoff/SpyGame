//
//  RulesModel.swift
//  Spy
//
//  Created by Вячеслав on 11/12/23.
//

import SwiftUI

//struct RulesModel: Hashable {
//    
//    var id: Int
//    
//    var mainPoint: String
//    var subPoint: String
//    
//    var title: String
//}


struct RulesModel {
    
    var id: Int
    var mainPoint: String
    var subPoints: [SubPoint]
}

struct SubPoint {
    
    var identifier: Int
    var id: String
    var title: String
}
