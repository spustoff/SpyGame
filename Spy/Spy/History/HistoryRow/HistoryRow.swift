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
        
        HStack(spacing: 12) {
            
            Image("\(item.isSpyWon ? "sunglasses.fill" : "figure.arms.open")")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(item.isSpyWon ? Color.prime : Color.second)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 0, content: {
                
                Text(item.isSpyWon ? "Spy won" : "The Peacefuls won")
                    .foregroundColor(item.isSpyWon ? Color.prime : .textWhite)
                    .font(.system(size: 17, weight: .medium))
                    .multilineTextAlignment(.leading)
                
                Text((item.gameDate ?? Date()).convertDate(format: "dd MMM, HH:mm"))
                    .foregroundColor(.textWhite60)
                    .font(.system(size: 13, weight: .medium))
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
                
                HStack(spacing: -18) {
                    
                    ForEach(filteredPlayersArray.prefix(3), id: \.id) { player in
                        
                        Image(player.playerPhoto.isEmpty ? "avatar_name" : player.playerPhoto)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(Color.bgPrime, lineWidth: 2)
                            )
                    }
                }
            }
            
            Image("chevron.right")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(Color.second)
                .padding(.leading, -12)
                .colorScheme(.dark)
        }
        .padding(.horizontal, 12)
        .frame(height: 64)
        .background(RoundedRectangle(cornerRadius: 12).fill(.bgCell))
        .padding(.horizontal)
    }
}

//#Preview {
//    HistoryRow(item: HistoryModel())
//}
