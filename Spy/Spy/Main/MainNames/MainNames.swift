//
//  MainNames.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

struct MainNames: View {
    
    @StateObject var viewModel: MainViewModel
    @StateObject var dataManager: DataManager
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                Text(viewModel.currentStep.text)
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .bold))
                
                HStack {
                    
                    Button(action: {
                        
                        viewModel.viewSwitcher(.minus)
                        
                    }, label: {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("bezhev"))
                            .font(.system(size: 17, weight: .semibold))
                    })
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    ForEach(0..<viewModel.playersCount, id: \.self) { index in
                        
                        if index < viewModel.playerNames.count {
                            
                            let player = viewModel.playerNames[index]
                            
                            HStack {
                                
                                Image(player.playerPhoto)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35)
                                    .overlay (
                                    
                                        Image(systemName: "camera.fill")
                                            .foregroundColor(Color("bezhev"))
                                            .font(.system(size: 8, weight: .regular))
                                            .padding(6)
                                            .background(
                                                
                                                Circle()
                                                    .fill(Color("bg"))
                                                    .opacity(player.playerPhoto == "avatar_name" ? 0 : 1)
                                            )
                                            .offset(x: 10, y: 10)
                                    )
                                    .onTapGesture {
                                        
                                        if !player.playerName.isEmpty {
                                            
                                            viewModel.selectedPlayerForPicker = viewModel.playerNames[index]
                                            viewModel.toPickerFromScreen = .names
                                            viewModel.currentStep = .pickAvatar
                                        }
                                    }
                                
                                ZStack(alignment: .leading, content: {
                                    
                                    Text("Name...")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14, weight: .regular))
                                        .opacity(player.playerName.isEmpty ? 1 : 0)
                                    
                                    TextField("", text: Binding<String>(
                                        get: { self.viewModel.playerNames[index].playerName },
                                        set: { newName in
                                            var updatedPlayer = self.viewModel.playerNames[index]
                                            updatedPlayer.playerName = newName
                                            self.viewModel.updatePlayer(at: index, with: updatedPlayer)
                                        }
                                    ))
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .medium))
                                })
                                
                                Spacer()
                                
                                if !player.playerName.isEmpty {
                                    
                                    Button(action: {
                                        
                                        dataManager.savePlayer(player: player)
                                        
                                    }, label: {
                                        
                                        Image(systemName: dataManager.isSavedPlayer(player) ? "star.fill" : "star")
                                            .foregroundColor(dataManager.isSavedPlayer(player) ? Color("bezhev") : .gray)
                                            .font(.system(size: 19, weight: .regular))
                                    })
                                }
                                
                                Button(action: {
                                    
                                    viewModel.selectedNameForFavorite = index
                                    viewModel.currentStep = .nameFavorites
                                    
                                }, label: {
                                    
                                    Image("favorites_reorder.icon")
                                })
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 13).fill(Color("bgGray")))
                        }
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2.5)
            
            Button(action: {
                
                viewModel.setupPlayers()
                
            }, label: {
                
                Text("PLAY!")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
            })
            .buttonStyle(ScaledButton(scaling: 0.9))
            .opacity(viewModel.playerNames.allSatisfy { !$0.playerName.isEmpty } ? 1 : 0.5)
            .disabled(viewModel.playerNames.allSatisfy { !$0.playerName.isEmpty } ? false : true)
        }
    }
}

#Preview {
    MainNames(viewModel: MainViewModel(), dataManager: DataManager())
}
