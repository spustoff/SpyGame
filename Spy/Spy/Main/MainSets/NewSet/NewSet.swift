//
//  NewSet.swift
//  Spy
//
//  Created by Вячеслав on 11/13/23.
//

import SwiftUI

struct NewSet: View {
    
    @StateObject var viewModel: MainViewModel
    @StateObject var setsModel: MainSetsViewModel
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                Text(viewModel.currentStep.text)
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .bold))
                
                HStack {
                    
                    Button(action: {
                        
                        setsModel.clearData()
                        viewModel.currentStep = .sets
                        
                    }, label: {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("bezhev"))
                            .font(.system(size: 17, weight: .semibold))
                    })
                    
                    Spacer()
                    
                    if !(setsModel.selectedSetForEdit == nil) {
                        
                        Button(action: {
                            
                            viewModel.currentStep = .sets
                            
                            CoreDataStack.shared.deleteSet(withUniqueID: Int64(setsModel.selectedSetForEdit?.id ?? 0), completion: {
                                
                                setsModel.isCoreDataFetched = false
                                setsModel.fetchCoreSets()
                                
                                setsModel.clearData()
                            })
                            
                        }, label: {
                            
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 17, weight: .semibold))
                        })
                    }
                }
                .padding(.horizontal)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    if let image = setsModel.imageSet {
                        
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 170)
                            .cornerRadius(radius: 15, corners: .allCorners)
                            .overlay (
                            
                                VStack(alignment: .trailing, content: {
                                    
                                    Button(action: {
                                        
                                        setsModel.imageSet = nil
                                        
                                    }, label: {
                                        
                                        Image(systemName: "xmark")
                                            .foregroundColor(Color("primary"))
                                            .font(.system(size: 13, weight: .regular))
                                            .padding(7)
                                            .background(Circle().fill(Color("bg")))
                                    })
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        setsModel.isAddPhoto = true
                                        
                                    }, label: {
                                        
                                        Image(systemName: "pencil")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 13, weight: .regular))
                                            .padding(7)
                                            .background(Circle().fill(Color("bg")))
                                    })
                                })
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            )
                        
                    } else {
                        
                        Button(action: {
                            
                            setsModel.isAddPhoto = true
                            
                        }, label: {
                            
                            VStack(alignment: .center, spacing: 7, content: {
                                
                                Image(systemName: "camera")
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 18, weight: .regular))
                                
                                Text("ADD PHOTO")
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 14, weight: .medium))
                            })
                            .frame(maxWidth: .infinity)
                            .frame(height: 170)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bgGray")))
                            .overlay(
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, dash: [10, 13]))
                                    .foregroundColor(Color("primary"))
                            )
                        })
                        .buttonStyle(ScaledButton(scaling: 0.9))
                    }
                    
                    ZStack(alignment: .leading, content: {
                        
                        Text("Name of the set...")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .regular))
                            .opacity(setsModel.nameSet.isEmpty ? 1 : 0)
                        
                        TextField("", text: $setsModel.nameSet)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .regular))
                    })
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("bgGray")))
                    
                    VStack(alignment: .leading, spacing: 15, content: {
                        
                        HStack(spacing: 10, content: {
                            
                            Image("roles.icon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 21, height: 21)
                            
                            Text("Roles")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .medium))
                            
                            Spacer()
                            
                            Button(action: {
                                
                                setsModel.roles.append(RoleItem(name: ""))
                                
                            }, label: {
                                
                                Image(systemName: "plus")
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 18, weight: .regular))
                            })
                        })
                        
                        ForEach($setsModel.roles) { $index in
                            
                            HStack {
                                
                                ZStack(alignment: .leading) {
                                    
                                    Text("Enter the role...")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14, weight: .regular))
                                        .opacity(index.name.isEmpty ? 1 : 0)
                                    
                                    TextField("", text: $index.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .regular))
                                }
                                
                                Spacer()
                                
                                if !index.name.isEmpty && setsModel.roles.count != 1 {
                                    
                                    Button(action: {
                                        
                                        if let index = setsModel.roles.firstIndex(where: { $0.id == index.id }) {
                                            
                                            setsModel.roles.remove(at: index)
                                        }
                                        
                                    }, label: {
                                        
                                        Image(systemName: "xmark")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 15, weight: .regular))
                                    })
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("bgGray")))
                        }
                    })
                    
                    VStack(alignment: .leading, spacing: 15, content: {
                        
                        HStack(spacing: 10, content: {
                            
                            Image("locations.icon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 21, height: 21)
                            
                            Text("Cards")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .medium))
                            
                            Spacer()
                            
                            Button(action: {
                                
                                setsModel.locations.append(LocationItem(name: ""))
                                
                            }, label: {
                                
                                Image(systemName: "plus")
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 18, weight: .regular))
                            })
                        })
                        
                        ForEach($setsModel.locations) { $index in
                            
                            HStack {
                                
                                ZStack(alignment: .leading) {
                                    
                                    Text("Location name...")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14, weight: .regular))
                                        .opacity(index.name.isEmpty ? 1 : 0)
                                    
                                    TextField("", text: $index.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .regular))
                                }
                                
                                Spacer()
                                
                                if !index.name.isEmpty && setsModel.locations.count != 1 {
                                    
                                    Button(action: {
                                        
                                        if let index = setsModel.locations.firstIndex(where: { $0.id == index.id }) {
                                            
                                            setsModel.locations.remove(at: index)
                                        }
                                        
                                    }, label: {
                                        
                                        Image(systemName: "xmark")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 15, weight: .regular))
                                    })
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("bgGray")))
                        }
                    })
                    
                    VStack(alignment: .leading, spacing: 15, content: {
                        
                        HStack(spacing: 6, content: {
                            
                            Image("hints.icon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                            
                            Text("Hints")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .medium))
                            
                            Spacer()
                            
                            Button(action: {
                                
                                setsModel.hints.append(HintItem(name: ""))
                                
                            }, label: {
                                
                                Image(systemName: "plus")
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 18, weight: .regular))
                            })
                        })
                        
                        ForEach($setsModel.hints) { $index in
                            
                            HStack {
                                
                                ZStack(alignment: .leading) {
                                    
                                    Text("Enter a hint...")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14, weight: .regular))
                                        .opacity(index.name.isEmpty ? 1 : 0)
                                    
                                    TextField("", text: $index.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .regular))
                                }
                                
                                Spacer()
                                
                                if !index.name.isEmpty && setsModel.hints.count != 1 {
                                    
                                    Button(action: {
                                        
                                        if let index = setsModel.hints.firstIndex(where: { $0.id == index.id }) {
                                            
                                            setsModel.hints.remove(at: index)
                                        }
                                        
                                    }, label: {
                                        
                                        Image(systemName: "xmark")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 15, weight: .regular))
                                    })
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("bgGray")))
                        }
                    })
                }
            }
            .frame(height: UIScreen.main.bounds.height / 1.7)
            
            HStack {
                
                Button(action: {
                    
                    setsModel.clearData()
                    viewModel.currentStep = .sets
                    
                }, label: {
                    
                    Text("CANCEL")
                        .foregroundColor(Color("primary"))
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color("bgGray")))
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                
                Button(action: {
                    
                    if setsModel.selectedSetForEdit == nil {
                        
                        setsModel.addSet(completion: {})
                        
                    } else {
                        
                        setsModel.updateSet(completion: {})
                    }
                    
                    setsModel.isCoreDataFetched = false
                    setsModel.fetchCoreSets()
                    
                    viewModel.currentStep = .sets
                    setsModel.clearData()
                    
                    if !viewModel.isReviewedAlready {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            
                            viewModel.isReviewView = true
                        }
                    }
                    
                }, label: {
                    
                    Text("SAVE")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .opacity(setsModel.nameSet.isEmpty || !setsModel.roles.allSatisfy { !$0.name.isEmpty } || !setsModel.locations.allSatisfy { !$0.name.isEmpty } ? 0.5 : 1)
                .disabled(setsModel.nameSet.isEmpty || !setsModel.roles.allSatisfy { !$0.name.isEmpty } || !setsModel.locations.allSatisfy { !$0.name.isEmpty } ? true : false)
            }
        }
        .sheet(isPresented: $setsModel.isAddPhoto) {
            
            ImagePicker(selectedImage: $setsModel.imageSet)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NewSet(viewModel: MainViewModel(), setsModel: MainSetsViewModel())
}
