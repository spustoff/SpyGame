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
                    .font(.system(size: 21, weight: .bold))
                
                HStack {
                    
                    Button(action: {
                        
                        viewModel.currentStep = .names
                        
                    }, label: {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("bezhev"))
                            .font(.system(size: 17, weight: .semibold))
                    })
                    
                    Spacer()
                    
                    if !dataManager.saved_users.isEmpty {
                        
                        Button(action: {
                            
                            isEditing.toggle()
                            
                        }, label: {
                            
                            Image(systemName: isEditing ? "checkmark" : "pencil")
                                .foregroundColor(Color("bezhev"))
                                .font(.system(size: isEditing ? 15 : 17, weight: .semibold))
                                .background (
                                
                                    Circle()
                                        .fill(Color("bgGray"))
                                        .frame(width: 30, height: 30)
                                        .opacity(isEditing ? 1 : 0)
                                )
                        })
                        .buttonStyle(ScaledButton(scaling: 0.7))
                    }
                }
                .padding(.horizontal)
            }
            
            let data = dataManager.saved_users.indices.filter { index in
                !viewModel.playerNames.contains(where: { $0.playerName == dataManager.saved_users[index].playerName })
            }
            
            if data.isEmpty {
                
                VStack(alignment: .center, spacing: 10, content: {
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.gray.opacity(0.5))
                        .font(.system(size: 40, weight: .regular))
                    
                    VStack(alignment: .center, spacing: 5, content: {
                        
                        Text("Favorites list is empty")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .multilineTextAlignment(.center)
                        
                        Text("Create a new one or click on the star in the list of players")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 14, weight: .regular))
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
                                    
                                    Image(dataManager.saved_users[index].playerPhoto)
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
                                                        .opacity(dataManager.saved_users[index].playerPhoto == "avatar_name" ? 0 : 1)
                                                )
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
                                            .font(.system(size: 14, weight: .regular))
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
                                            
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color("primary"))
                                                .font(.system(size: 19, weight: .medium))
                                        })
                                        
                                    } else {
                                        
                                        Circle()
                                            .stroke(selectedFavorite == dataManager.saved_users[index] ? Color("primary") : .gray.opacity(0.5), lineWidth: 1.5)
                                            .frame(width: 18, height: 18)
                                            .overlay (
                                            
                                                Circle()
                                                    .fill(Color("primary"))
                                                    .frame(width: 14, height: 14)
                                                    .opacity(selectedFavorite == dataManager.saved_users[index] ? 1 : 0)
                                            )
                                    }
                                }
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(RoundedRectangle(cornerRadius: 13).fill(Color("bgGray")))
                                .overlay (
                                
                                    RoundedRectangle(cornerRadius: 13)
                                        .stroke(Color("primary"), lineWidth: 1.2)
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
                
                Button(action: {
                    
                    let newIndex = dataManager.saved_users.count
                
                    dataManager.addUser()

                    self.tempName = ""
                    self.editingIndex = newIndex
                    self.isKeyboard = true
                    
                }, label: {
                    
                    HStack {
                        
                        Image(systemName: "plus")
                            .foregroundColor(Color("primary"))
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("NEW")
                            .foregroundColor(Color("primary"))
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color("bgGray")))
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                
                Button(action: {
                    
                    viewModel.playerNames[viewModel.selectedNameForFavorite] = selectedFavorite ?? PlayersModel(id: 1, playerName: "", playerPhoto: "", playerRole: "")
                    
                    viewModel.currentStep = .names
                    
                    selectedFavorite = nil
                    
                }, label: {
                    
                    Text("SELECT")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .opacity(selectedFavorite == nil ? 0.5 : 1)
                .disabled(selectedFavorite == nil ? true : false)
            }
        }
    }
}

#Preview {
    NamesFavorites(viewModel: MainViewModel(), dataManager: DataManager())
}
