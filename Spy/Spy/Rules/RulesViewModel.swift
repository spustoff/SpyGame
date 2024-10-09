//
//  RulesViewModel.swift
//  Spy
//
//  Created by Вячеслав on 11/12/23.
//

import SwiftUI

final class RulesViewModel: ObservableObject {
    
    @Published var isDetail: Bool = false
    @Published var current_rule: Int = 1
    
    @Published var rule_screens: [RulesModel] = [

        RulesModel(id: 1, mainPoint: "1. Before the game starts", subPoints: [
        
            SubPoint(identifier: 1, id: "1.1", title: "About the game"),
            SubPoint(identifier: 2, id: "1.2", title: "Tasks of the players"),
            SubPoint(identifier: 3, id: "1.3", title: "Preparation"),
            SubPoint(identifier: 4, id: "1.4", title: "Optional"),
        ]),
        
        RulesModel(id: 2, mainPoint: "2. Beginning of the game", subPoints: [
        
            SubPoint(identifier: 5, id: "2.1", title: "Gameplay"),
            SubPoint(identifier: 6, id: "2.2", title: "Example of a game round"),
        ]),
        
        RulesModel(id: 3, mainPoint: "3. Ending the game", subPoints: [
        
            SubPoint(identifier: 7, id: "3.1", title: "When the timer expires"),
            SubPoint(identifier: 8, id: "3.2", title: "After the vote"),
            SubPoint(identifier: 9, id: "3.3", title: "At the will of the spy"),
            SubPoint(identifier: 10, id: "3.4", title: "And more rules"),
        ]),
    ]
    
    public func getPoints() -> [SubPoint] {
        
        return rule_screens.flatMap(\.subPoints)
    }
}
