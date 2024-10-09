//
//  DataManager.swift
//  Spy
//
//  Created by Вячеслав on 11/12/23.
//

import SwiftUI

final class DataManager: ObservableObject {
    
    @AppStorage("saved_players") var savedPlayersData: Data = Data()
    
    var saved_users: [PlayersModel] {
        
        get {
            (try? JSONDecoder().decode([PlayersModel].self, from: savedPlayersData)) ?? []
        }
        set {
            savedPlayersData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
    
    func savePlayer(player: PlayersModel) {
        
        var players = saved_users
        
        if let index = players.firstIndex(where: { $0.playerName == player.playerName }) {
            
            players.remove(at: index)
            
        } else {
            
            players.append(player)
        }
        
        saved_users = players
    }
    
    func isSavedPlayer(_ player: PlayersModel) -> Bool {
        
        saved_users.contains(where: { $0.playerName == player.playerName })
    }
    
    func addUser() {
        
        withAnimation(.spring()) {
            
            saved_users.append(PlayersModel(id: Int.random(in: 1...50), playerName: "\(saved_users.count + 1)", playerPhoto: "avatar_name", playerRole: "nil"))
        }
    }
}
