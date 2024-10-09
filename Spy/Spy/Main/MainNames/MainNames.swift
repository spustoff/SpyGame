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
                    .font(.system(size: 19, weight: .bold))
                
                HStack {
                    
                    Button(action: {
                        
                        viewModel.viewSwitcher(.minus)
                        
                    }, label: {
                        Icon(image: "chevron.left")
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
                                
                                Icon(image: "person.circle")
                                    .frame(width: 40, height: 40)
                                    .background(Color.bgCell)
                                    .embedInCornRadius(cornradius: 100)
                                    .overlay(
                                        Image(player.playerPhoto)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                            .embedInCornRadius(cornradius: 100)
                                            .opacity(player.playerPhoto.isEmpty ? 0 : 1)
                                    )
                                    .overlay (
                                    
                                        Image(systemName: "camera.fill")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(Color.second)
                                            .frame(width: 19, height: 19)
                                            .background(Color.bg)
                                            .embedInCornRadius(cornradius: 100)
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
                                        .font(.system(size: 17, weight: .medium))
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
                                        .font(.system(size: 17, weight: .medium))
                                })
                                
                                Spacer()
                                
                                if !player.playerName.isEmpty {
                                    
                                    Button(action: {
                                        
                                        dataManager.savePlayer(player: player)
                                        
                                    }, label: {
                                        Icon(image: dataManager.isSavedPlayer(player) ? "star.fill" : "star")
                                    })
                                }
                                
                                Button(action: {
                                    
                                    viewModel.selectedNameForFavorite = index
                                    viewModel.currentStep = .nameFavorites
                                    
                                }, label: {
                                    Icon(image: "text.badge.star")
                                })
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                        }
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2.5)
            
            let isDisSave = viewModel.playerNames.allSatisfy { !$0.playerName.isEmpty }
            Button(action: {
                
                viewModel.setupPlayers()
                
            }, label: {
                
                Text("PLAY!")
                    .font(.body.bold())
                    .foregroundColor(!isDisSave ? .textWhite40 : .textWhite)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [!isDisSave ? Color.bgButtonDisabled : Color.primeTopTrailGrad,
                                                !isDisSave ? Color.bgButtonDisabled : Color.primeBotLeadGrad],
                                       startPoint: .topTrailing,
                                       endPoint: .bottomLeading)
                    )
                    .embedInCornRadius(cornradius: 16)
            })
            .buttonStyle(ScaledButton(scaling: 0.9))
            .opacity(isDisSave ? 1 : 0.5)
            .disabled(isDisSave ? false : true)
        }
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        MainNames(viewModel: MainViewModel(), dataManager: DataManager())
    }
}
