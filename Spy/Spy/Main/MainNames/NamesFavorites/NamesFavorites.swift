//
//  NamesFavorites.swift
//  Spy
//
//  Created by Вячеслав on 11/13/23.
//

import SwiftUI

struct NamesFavorites: View {
    
    @StateObject var viewModel: MainViewModel
    @StateObject var dataManager: DataManager
    
    @State private var selectedFavorite: PlayersModel? = nil
    @State private var tempName: String = ""
    @State private var editingIndex: Int? = nil
    @State private var isKeyboard: Bool = false
    @State private var isEditing: Bool = false
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                Text(viewModel.currentStep.text)
                    .foregroundColor(.white)
                    .font(.system(size: 19, weight: .bold))
                
                HStack {
                    if !dataManager.saved_users.isEmpty {
                        
                        if isEditing {
                            Button(action: {
                                
                                isEditing.toggle()
                                
                            }, label: {
                                
                                Icon(image: "pencil")
                            })
                            .buttonStyle(ScaledButton(scaling: 0.7))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        viewModel.currentStep = .names
                        
                    }, label: {
                        Image("xmark")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(.second)
                    })
                }
                .padding(.horizontal)
            }
            
            let data = dataManager.saved_users.indices.filter { index in
                !viewModel.playerNames.contains(where: { $0.playerName == dataManager.saved_users[index].playerName })
            }
            
            if data.isEmpty {
                
                VStack(alignment: .center, spacing: 0, content: {
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.textWhite40)
                        .font(.system(size: 48, weight: .regular))
                        .frame(width: 80, height: 80)
                    
                    VStack(alignment: .center, spacing: 5, content: {
                        
                        Text("Favorites list is empty")
                            .foregroundColor(.white)
                            .font(.system(size: 19, weight: .bold))
                            .multilineTextAlignment(.center)
                        
                        Text("Create a new one or click on the star in the list of players")
                            .foregroundColor(.textWhite60)
                            .font(.system(size: 17, weight: .regular))
                            .multilineTextAlignment(.center)
                    })
                })
                .frame(height: UIScreen.main.bounds.height / 2.5)
                
            } else {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        
                        ForEach(data, id: \.self) { index in
                        
                            Button(action: {
                                
                                if selectedFavorite == dataManager.saved_users[index] {
                                    
                                    selectedFavorite = nil
                                    
                                } else {
                                    
                                    selectedFavorite = dataManager.saved_users[index]
                                }
                                
                            }, label: {
                                
                                HStack {
                                    Icon(image: "person.circle")
                                        .frame(width: 40, height: 40)
                                        .background(Color.bgCell)
                                        .embedInCornRadius(cornradius: 100)
                                        .overlay(
                                            Image(dataManager.saved_users[index].playerPhoto)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 40, height: 40)
                                                .embedInCornRadius(cornradius: 100)
                                                .opacity(dataManager.saved_users[index].playerPhoto.isEmpty ? 0 : 1)
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
                                            
                                            if !dataManager.saved_users[index].playerName.isEmpty {
                                                
                                                viewModel.selectedPlayerForPicker = dataManager.saved_users[index]
                                                viewModel.toPickerFromScreen = .nameFavorites
                                                viewModel.currentStep = .pickAvatar
                                            }
                                        }
                                    
                                    if editingIndex == index {
                                        
                                        RespondedTextField(text: $tempName, isFirstResponder: $isKeyboard, onCommit: {
                                            
                                            if !dataManager.saved_users.contains(where: {$0.playerName == tempName}) {
                                                
                                                let updatedPlayer = PlayersModel(id: dataManager.saved_users[index].id, playerName: tempName, playerPhoto: dataManager.saved_users[index].playerPhoto, playerRole: dataManager.saved_users[index].playerRole)
                                                dataManager.saved_users[index] = updatedPlayer
                                                editingIndex = nil
                                            }
                                        })
                                        .frame(height: 20)
                                        
                                    } else {
                                        
                                        Text(dataManager.saved_users[index].playerName)
                                            .foregroundColor(.white)
                                            .font(.system(size: 17, weight: .medium))
                                            .onTapGesture {
                                                
                                                self.isKeyboard = true
                                                self.tempName = dataManager.saved_users[index].playerName
                                                self.editingIndex = index
                                            }
                                    }
                                    
                                    Spacer()
                                    
                                    if isEditing {
                                        
                                        Button(action: {
                                            
                                            withAnimation(.spring()) {
                                                
                                                dataManager.savePlayer(player: dataManager.saved_users[index])
                                            }
                                            
                                        }, label: {
                                            Icon(image: "xmark")
                                        })
                                        
                                    } else {
                                        Icon(image: selectedFavorite == dataManager.saved_users[index] ? "button.programmable" : "circle")
                                    }
                                }
                                .padding(.horizontal, 12)
                                .frame(height: 60)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                                .overlay (
                                
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.prime, lineWidth: 2)
                                        .opacity(selectedFavorite == dataManager.saved_users[index] ? 1 : 0)
                                )
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                        }
                    }
                    .padding(1)
                }
                .frame(height: UIScreen.main.bounds.height / 2.5)
            }
            
            HStack {
                
                if  !isEditing {
                    Button(action: {
                        
                        let newIndex = dataManager.saved_users.count
                        
                        dataManager.addUser()
                        
                        self.tempName = ""
                        self.editingIndex = newIndex
                        self.isKeyboard = true
                        
                    }, label: {
                        
                        HStack(spacing: 2) {
                            
                            Image("plus")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .foregroundColor(.prime)
                            
                            Text("NEW")
                                .foregroundColor(Color("primary"))
                                .font(.system(size: 17, weight: .bold))
                        }
                        .font(.body.bold())
                        .foregroundColor(.prime)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.bgButton)
                        .embedInCornRadius(cornradius: 16)
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                }
                
                let isDisSave = selectedFavorite == nil
                Button(action: {
                    if isEditing {
                        isEditing.toggle()
                    } else {
                        viewModel.playerNames[viewModel.selectedNameForFavorite] = selectedFavorite ?? PlayersModel(id: 1, playerName: "", playerPhoto: "", playerRole: "")
                        
                        viewModel.currentStep = .names
                        
                        selectedFavorite = nil
                    }
                }, label: {
                    
                    Text(isEditing ? "DONE" : "SELECT")
                        .font(.body.bold())
                        .foregroundColor(isDisSave ? .textWhite40 : .textWhite)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(colors: [isDisSave ? Color.bgButtonDisabled : Color.primeTopTrailGrad,
                                                    isDisSave ? Color.bgButtonDisabled : Color.primeBotLeadGrad],
                                           startPoint: .topTrailing,
                                           endPoint: .bottomLeading)
                        )
                        .embedInCornRadius(cornradius: 16)
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .opacity(isDisSave ? 0.5 : 1)
                .disabled(isDisSave ? true : false)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        NamesFavorites(viewModel: MainViewModel(), dataManager: DataManager())
    }
}
