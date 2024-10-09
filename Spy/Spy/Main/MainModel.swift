//
//  MainModel.swift
//  Spy
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct PlayersModel: Codable, Hashable {
    
    var id: Int
    
    var playerName: String
    var playerPhoto: String
    var playerRole: String
}

enum VotingSteps: CaseIterable {
    
    case main, voting, result, question, spyLeft
}

enum SetTypesSelected {
    
    case edit, main
}

extension PlayersModel {
    
    func toJSONData() -> Data? {
        
        return try? JSONEncoder().encode(self)
    }

    static func fromJSONData(_ data: Data) -> PlayersModel? {
        
        return try? JSONDecoder().decode(PlayersModel.self, from: data)
    }
}
