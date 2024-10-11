//
//  HistoryDetail.swift
//  Spy
//
//  Created by Вячеслав on 11/25/23.
//

import SwiftUI

struct HistoryDetail: View {
    
    @Environment(\.presentationMode) var router
    @Binding var isActive: Bool
    
    let item: HistoryModel
    
    @EnvironmentObject var viewModel: MainViewModel
    @StateObject var historyModel = HistoryViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color.bgPrime.ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("Game #\(item.gameID)")
                        .foregroundColor(.textWhite)
                        .font(.system(size: 19, weight: .semibold))
                    
                    HStack {
                        
                        Button(action: {
                            
                            if historyModel.isReviewedAlready {
                                
                                router.wrappedValue.dismiss()
                                
                            } else if !historyModel.isReviewedAlready {
                                
                                historyModel.isReviewView = true
                            }

                        }, label: {
                            Icon(image: "chevron.left")
                        })
                        
                        Spacer()
                    }
                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack(spacing: 24) {
                        
                        VStack(spacing: 16) {
                            
                            if let coreDataPlayersSet = item.playersModel as? Set<PlayersCoreModel> {
                                
                                let sortedPlayersArray = coreDataPlayersSet
                                    .sorted(by: { $0.playerID < $1.playerID })
                                    .map { corePlayer in
                                        
                                        PlayersModel(id: Int(corePlayer.playerID), playerName: corePlayer.playerName ?? "", playerPhoto: corePlayer.playerPhoto ?? "", playerRole: corePlayer.playerRole ?? "")
                                    }
                                
                                let filteredPlayersArray = item.isSpyWon
                                        ? sortedPlayersArray.filter { $0.playerRole == "Spy" }
                                        : sortedPlayersArray.filter { $0.playerRole != "Spy" }
                                
                                HStack(spacing: -60) {
                                    
                                    ForEach(filteredPlayersArray.prefix(5), id: \.id) { player in
                                        
                                        Image(player.playerPhoto.isEmpty ? "avatar_name" : player.playerPhoto)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80, height: 80)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.cornHistory, lineWidth: 4)
                                            )
                                    }
                                }
                            }
                            
                            let wonText = item.isSpyWon ? item.spyCount == 1 ? "The spy won!" : "The spies won!" : "The Peacefuls have won!"
                            
                            Text(NSLocalizedString(wonText, comment: ""))
                                .foregroundColor(Color.second)
                                .font(.system(size: 34, weight: .semibold))
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                
                                if let coreDataPlayersSet = item.playersModel as? Set<PlayersCoreModel> {
                                    
                                    let sortedPlayersArray = coreDataPlayersSet
                                        .sorted(by: { $0.playerID < $1.playerID })
                                        .map { corePlayer in
                                            
                                            PlayersModel(id: Int(corePlayer.playerID), playerName: corePlayer.playerName ?? "", playerPhoto: corePlayer.playerPhoto ?? "", playerRole: corePlayer.playerRole ?? "")
                                        }
                                    
                                    let filteredPlayersArray = item.isSpyWon
                                            ? sortedPlayersArray.filter { $0.playerRole != "Spy" }
                                            : sortedPlayersArray.filter { $0.playerRole == "Spy" }
                                    
                                    HStack(spacing: -18) {
                                        
                                        ForEach(filteredPlayersArray.prefix(6), id: \.id) { player in
                                            
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
                                
                                let lostText = item.isSpyWon ? "The Peacefuls lost" : item.spyCount == 1 ? "The spy lost!" : "The spies lost!"
                                
                                Text(NSLocalizedString(lostText, comment: ""))
                                    .foregroundColor(Color.prime)
                                    .font(.system(size: 17, weight: .medium))
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(
                            
                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color.bgButton)
                                .overlay (
                                    Image("winnerCell")
                                        .resizable()
                                )
//                                .background(Color.bgPrime)
                        )
                        
//                        Text("Players")
//                            .foregroundColor(.white)
//                            .font(.system(size: 18, weight: .medium))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.top)
//                        
//                        if let coreDataPlayersSet = item.playersModel as? Set<PlayersCoreModel> {
//                            
//                            let sortedPlayersArray = coreDataPlayersSet
//                                .sorted(by: { $0.playerID < $1.playerID })
//                                .map { corePlayer in
//                                    
//                                    PlayersModel(id: Int(corePlayer.playerID), playerName: corePlayer.playerName ?? "", playerPhoto: corePlayer.playerPhoto ?? "", playerRole: corePlayer.playerRole ?? "")
//                                }
//                            
//                            let winners = item.isSpyWon
//                                    ? sortedPlayersArray.filter { $0.playerRole == "Spy" }
//                                    : sortedPlayersArray.filter { $0.playerRole != "Spy" }
//                            
//                            
//                            VStack(alignment: .leading, spacing: 20, content: {
//                                
//                                HStack {
//                                    
//                                    Text("Winners")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 14, weight: .medium))
//                                    
//                                    Spacer()
//                                    
//                                    Text("\(winners.count)")
//                                        .foregroundColor(.gray)
//                                        .font(.system(size: 12, weight: .regular))
//                                }
//                                
//                                ScrollView(.horizontal, showsIndicators: false) {
//                                    
//                                    HStack(spacing: 5) {
//                                        
//                                        ForEach(winners, id: \.self) { index in
//                                        
//                                            VStack(alignment: .center, spacing: 10, content: {
//                                                
//                                                Image(index.playerPhoto.isEmpty ? "avatar_name" : index.playerPhoto)
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .frame(width: 40, height: 40)
//                                                
//                                                Text(index.playerName)
//                                                    .foregroundColor(.white)
//                                                    .font(.system(size: 12, weight: .medium))
//                                                    .lineLimit(2)
//                                                    .multilineTextAlignment(.center)
//                                                    .frame(width: 60)
//                                                
//                                                Spacer()
//                                            })
//                                        }
//                                    }
//                                }
//                            })
//                            .padding([.horizontal, .top])
//                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
//                        }
//                        
//                        if let coreDataPlayersSet = item.playersModel as? Set<PlayersCoreModel> {
//                            
//                            let sortedPlayersArray = coreDataPlayersSet
//                                .sorted(by: { $0.playerID < $1.playerID })
//                                .map { corePlayer in
//                                    
//                                    PlayersModel(id: Int(corePlayer.playerID), playerName: corePlayer.playerName ?? "", playerPhoto: corePlayer.playerPhoto ?? "", playerRole: corePlayer.playerRole ?? "")
//                                }
//                            
//                            let losers = item.isSpyWon
//                                    ? sortedPlayersArray.filter { $0.playerRole != "Spy" }
//                                    : sortedPlayersArray.filter { $0.playerRole == "Spy" }
//                            
//                            
//                            VStack(alignment: .leading, spacing: 20, content: {
//                                
//                                HStack {
//                                    
//                                    Text("Losers")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 14, weight: .medium))
//                                    
//                                    Spacer()
//                                    
//                                    Text("\(losers.count)")
//                                        .foregroundColor(.gray)
//                                        .font(.system(size: 12, weight: .regular))
//                                }
//                                
//                                ScrollView(.horizontal, showsIndicators: false) {
//                                    
//                                    HStack(spacing: 5) {
//                                        
//                                        ForEach(losers, id: \.self) { index in
//                                        
//                                            VStack(alignment: .center, spacing: 10, content: {
//                                                
//                                                Image(index.playerPhoto.isEmpty ? "avatar_name" : index.playerPhoto)
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .frame(width: 40, height: 40)
//                                                
//                                                Text(index.playerName)
//                                                    .foregroundColor(.white)
//                                                    .font(.system(size: 12, weight: .medium))
//                                                    .lineLimit(2)
//                                                    .multilineTextAlignment(.center)
//                                                    .frame(width: 60)
//                                                
//                                                Spacer()
//                                            })
//                                        }
//                                    }
//                                }
//                            })
//                            .padding([.horizontal, .top])
//                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
//                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About Game")
                                .foregroundColor(.textWhite)
                                .font(.system(size: 19, weight: .bold))
                            
//                            HStack {
//                                miniCardDesign(value: <#T##String#>, title: "The Peacefuls Won")
//                            }
                            
                            HStack {
                                
                                miniCardDesign(value: "\(item.playersCount)", title: "Players")
                                
                                miniCardDesign(value: "\(item.spyCount)", title: "Spies")
                                
                                miniCardDesign(value: item.time ?? "", title: "Time")
                            }
                            
                            HStack {
                                
                                miniCardDesign(value: "\(item.rounds)", title: "Rounds")
                                
                                miniCardDesign(value: "\(item.roles)", title: "Roles")
                                
                                miniCardDesign(value: item.isHints ? "Yes" : "No", title: "Hints")
                            }
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                
                                HStack {
                                    
                                    Text("Sets")
                                        .foregroundColor(.textWhite)
                                        .font(.system(size: 17, weight: .medium))
                                    
                                    Spacer()
                                    
                                    if let setModels = item.setModel as? Set<HistorySet> {
                                        
                                        Text("\(setModels.count)")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 15, weight: .regular))
                                    }
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack {
                                        
                                        if let setModels = item.setModel as? Set<HistorySet> {
                                            
                                            ForEach(Array(setModels), id: \.self) { setModel in
                                                
                                                let index = viewModel.convertHistorySetToModel(coreSetModel: setModel)
                                                
                                                VStack(alignment: .center, spacing: 6, content: {
                                                    
                                                    if index.coreDataImage == nil {
                                                        
                                                        Icon(image: "photo")
                                                            .frame(height: 106)
                                                            .frame(maxWidth: .infinity)
                                                    } else {
                                                        
                                                        if let coreImage = index.coreDataImage {
                                                            
                                                            Image(uiImage: coreImage)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(height: 106)
                                                                .cornerRadius(radius: 6, corners: [.topRight, .topLeft])
                                                            
                                                        }
                                                    }
                                                    
                                                    VStack(alignment: .center, spacing: 4, content: {
                                                        
                                                        Text(index.title ?? "nil")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 17, weight: .medium))
                                                            .multilineTextAlignment(.center)
                                                        
                                                        Text("\(index.totalLocations ?? 0) \(NSLocalizedString("Cards", comment: ""))")
                                                            .foregroundColor(.textWhite60)
                                                            .font(.system(size: 13, weight: .medium))
                                                    })
                                                    .padding(.horizontal, 6)
                                                    .padding(.bottom, 12)
                                                })
                                                .frame(maxWidth: .infinity)
                                                .frame(maxHeight: 165)
                                                .background(RoundedRectangle(cornerRadius: 6).fill(Color.bgCell))
                                                
//                                                VStack(alignment: .center, content: {
//                                                    
//                                                    if index.coreDataImage == nil && index.image == "" {
//                                                        
//                                                        Image(systemName: "camera")
//                                                            .foregroundColor(.gray)
//                                                            .font(.system(size: 14, weight: .regular))
//                                                            .frame(width: 140, height: 70)
//                                                            .background(Rectangle().fill(Color.gray.opacity(0.2)).cornerRadius(radius: 7, corners: [.topLeft, .topRight]))
//                                                        
//                                                    } else {
//                                                        
//                                                        if let coreImage = index.coreDataImage {
//                                                            
//                                                            Image(uiImage: coreImage)
//                                                                .resizable()
//                                                                .aspectRatio(contentMode: .fill)
//                                                                .frame(width: 140, height: 70)
//                                                                .cornerRadius(radius: 7, corners: [.topRight, .topLeft])
//                                                            
//                                                        }
//                                                    }
//                                                    
//                                                    Spacer()
//                                                    
//                                                    VStack(alignment: .center, spacing: 2, content: {
//                                                        
//                                                        Text(index.title ?? "")
//                                                            .foregroundColor(.white)
//                                                            .font(.system(size: 14, weight: .medium))
//                                                            .multilineTextAlignment(.center)
//                                                        
//                                                        Text("\(index.totalLocations ?? 0) locations")
//                                                            .foregroundColor(.gray)
//                                                            .font(.system(size: 12, weight: .regular))
//                                                    })
//                                                    .padding(13)
//                                                })
//                                                .frame(width: 140)
//                                                .frame(maxHeight: 230)
//                                                .background(RoundedRectangle(cornerRadius: 7).fill(Color.gray.opacity(0.1)))
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                }
                                .padding(.horizontal, -12)
                            })
                            .padding(.horizontal, 12)
                            .padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                            
                            if let setModels = item.setModel as? Set<HistorySet> {
                                
                                let allLocations = setModels.compactMap { getLocationsArray(from: $0) }.flatMap { $0 }
                                
                                VStack(alignment: .leading, spacing: 12, content: {
                                    
                                    HStack {
                                        
                                        Text("Cards")
                                            .foregroundColor(.white)
                                            .font(.system(size: 17, weight: .medium))
                                        
                                        Spacer()
                                        
                                        Text("\(allLocations.count)")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 15, weight: .regular))
                                    }
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        
                                        HStack(spacing: 4) {
                                            
                                            ForEach(allLocations, id: \.self) { index in
                                                
                                                VStack(alignment: .center, spacing: 4, content: {
                                                    
                                                    Image(systemName: "globe")
                                                        .foregroundColor(.textWhite40)
                                                        .font(.system(size: 21, weight: .regular))
                                                        .frame(width: 32, height: 32)
                                                        .background(Circle().fill(.bgCell))
                                                        .frame(width: 48, height: 48)
                                                    
                                                    Text(index.location ?? "")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 13, weight: .medium))
                                                        .lineLimit(2)
                                                        .multilineTextAlignment(.center)
                                                        .frame(width: 72)
                                                    
                                                    Spacer()
                                                })
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                    }
                                    .padding(.horizontal, -12)
                                })
                                .padding(.horizontal, 12)
                                .padding(.vertical, 14)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    
                    if historyModel.isReviewedAlready {
                        
//                        router.wrappedValue.dismiss()
                        viewModel.setupHistory(historyModel: item)
                        viewModel.isGame = true
                        isActive = false
                        
                    } else if !historyModel.isReviewedAlready {
                        
                        historyModel.isReviewView = true
                    }
                    
                }, label: {
                    PrimeButton(text: NSLocalizedString("PLAY IT AGAIN", comment: ""))
//                    Text("NEW GAME")
//                        .foregroundColor(.white)
//                        .font(.system(size: 16, weight: .medium))
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 50)
//                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
//                        .padding()
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $historyModel.isReviewView, content: {
            
            ReviewView()
        })
        
        
    }
    
    @ViewBuilder
    func miniCardDesign(value: String, title: String) -> some View {
        
        VStack(alignment: .center, spacing: 0, content: {
            
            Text(NSLocalizedString(value, comment: ""))
                .foregroundColor(.textWhite)
                .font(.system(size: 24, weight: .bold))
            
            Text(NSLocalizedString(title, comment: ""))
                .foregroundColor(.textWhite80)
                .font(.system(size: 15, weight: .regular))
        })
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
    }
    
    func getLocationsArray(from setModel: HistorySet) -> [Location]? {
        
        guard let locationsData = setModel.locations as? Data else {
            
            print("No locations data found")
            
            return []
        }

        let decoder = JSONDecoder()
        
        do {
            
            let locationsArray = try decoder.decode([Location].self, from: locationsData)
            
            return locationsArray
            
        } catch {
            
            print("Error decoding locations: \(error)")
            
            return []
        }
    }
}

//#Preview {
//    ZStack {
//        Color.bgPrime.ignoresSafeArea()
//        HistoryDetail(item: HistoryModel())
//    }
//}
