//
//  HistoryRow.swift
//  Spy
//
//  Created by Вячеслав on 11/25/23.
//

import SwiftUI

struct HistoryRow: View {
    
    let item: HistoryModel
    
    var body: some View {
        
        HStack {
            
            Image("\(item.isSpyWon ? "spies" : "persons").icon")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(item.isSpyWon ? Color("primary") : Color("bezhev"))
                .frame(width: 31, height: 31)
            
            VStack(alignment: .leading, spacing: 1, content: {
                
                Text(item.isSpyWon ? "Spy won" : "The Peacefuls won")
                    .foregroundColor(item.isSpyWon ? Color("primary") : .white)
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.leading)
                
                Text((item.gameDate ?? Date()).convertDate(format: "MMM d HH:mm"))
                    .foregroundColor(.white.opacity(0.6))
                    .font(.system(size: 12, weight: .regular))
            })
            
            Spacer()
            
            if let coreDataPlayersSet = item.playersModel as? Set<PlayersCoreModel> {
                
                let sortedPlayersArray = coreDataPlayersSet
                    .sorted(by: { $0.playerID < $1.playerID })
                    .map { corePlayer in
                        
                        PlayersModel(id: Int(corePlayer.playerID), playerName: corePlayer.playerName ?? "", playerPhoto: corePlayer.playerPhoto ?? "", playerRole: corePlayer.playerRole ?? "")
                    }
                
                let filteredPlayersArray = item.isSpyWon
                        ? sortedPlayersArray.filter { $0.playerRole == "Spy" }
                        : sortedPlayersArray.filter { $0.playerRole != "Spy" }
                
                HStack(spacing: -20) {
                    
                    ForEach(filteredPlayersArray.prefix(3), id: \.id) { player in
                        
                        Image(player.playerPhoto.isEmpty ? "avatar_name" : player.playerPhoto)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }
                }
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color("bezhev"))
                .font(.system(size: 15, weight: .regular))
        }
        .padding(.horizontal)
        .frame(height: 65)
        .background(RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.1)))
        .padding(.horizontal)
    }
}

//#Preview {
//    HistoryRow(item: HistoryModel())
//}
