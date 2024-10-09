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
                    .font(.system(size: 19, weight: .bold))
                
                HStack {
                    if !(setsModel.selectedSetForEdit == nil) {
                        
                        Button(action: {
                            
                            viewModel.currentStep = .sets
                            
                            CoreDataStack.shared.deleteSet(withUniqueID: Int64(setsModel.selectedSetForEdit?.id ?? 0), completion: {
                                
                                setsModel.isCoreDataFetched = false
                                setsModel.fetchCoreSets()
                                
                                setsModel.clearData()
                            })
                            
                        }, label: {
                            
                            Icon(image: "trash.fill")
                        })
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        setsModel.clearData()
                        viewModel.currentStep = .sets
                        
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
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    if let image = setsModel.imageSet {
                        
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 190)
                            .cornerRadius(radius: 12, corners: .allCorners)
                            .overlay (
                            
                                VStack(alignment: .trailing, content: {
                                    
                                    Button(action: {
                                        
                                        setsModel.imageSet = nil
                                        
                                    }, label: {
                                        
                                        Icon(image: "close circle")
                                    })
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        setsModel.isAddPhoto = true
                                        
                                    }, label: {
                                        Icon(image: "edit circle")
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
                                
                                Icon(image: "camera")
                                
                                Text("ADD PHOTO")
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 14, weight: .bold))
                            })
                            .frame(maxWidth: .infinity)
                            .frame(height: 190)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.bgCell))
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
                            .font(.system(size: 17, weight: .medium))
                            .opacity(setsModel.nameSet.isEmpty ? 1 : 0)
                        
                        TextField("", text: $setsModel.nameSet)
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .medium))
                    })
                    .padding(.horizontal, 12)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        HStack(spacing: 10, content: {
                            
                            Icon(image: "person.crop.circle.badge.questionmark")
                            
                            Text("Roles")
                                .foregroundColor(.white)
                                .font(.system(size: 19, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: {
                                
                                setsModel.roles.append(RoleItem(name: ""))
                                
                            }, label: {
                                Image("plus")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.prime)
                            })
                        })
                        
                        ForEach($setsModel.roles) { $index in
                            
                            HStack {
                                
                                ZStack(alignment: .leading) {
                                    
                                    Text("Enter the role...")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 17, weight: .medium))
                                        .opacity(index.name.isEmpty ? 1 : 0)
                                    
                                    TextField("", text: $index.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 17, weight: .medium))
                                }
                                
                                Spacer()
                                
                                if !index.name.isEmpty && setsModel.roles.count != 1 {
                                    
                                    Button(action: {
                                        
                                        if let index = setsModel.roles.firstIndex(where: { $0.id == index.id }) {
                                            
                                            setsModel.roles.remove(at: index)
                                        }
                                        
                                    }, label: {
                                        
                                        Image("xmark")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 32, height: 32)
                                            .foregroundColor(.textWhite40)
                                    })
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                        }
                    })
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        HStack(spacing: 10, content: {
                            
                            Icon(image: "globe.americas.fill")
                            
                            Text("Cards")
                                .foregroundColor(.white)
                                .font(.system(size: 19, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: {
                                
                                setsModel.locations.append(LocationItem(name: ""))
                                
                            }, label: {
                                
                                Image("plus")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.prime)
                            })
                        })
                        
                        ForEach($setsModel.locations) { $index in
                            
                            HStack {
                                
                                ZStack(alignment: .leading) {
                                    
                                    Text("Location name...")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 17, weight: .medium))
                                        .opacity(index.name.isEmpty ? 1 : 0)
                                    
                                    TextField("", text: $index.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 17, weight: .medium))
                                }
                                
                                Spacer()
                                
                                if !index.name.isEmpty && setsModel.locations.count != 1 {
                                    
                                    Button(action: {
                                        
                                        if let index = setsModel.locations.firstIndex(where: { $0.id == index.id }) {
                                            
                                            setsModel.locations.remove(at: index)
                                        }
                                        
                                    }, label: {
                                        
                                        Image("xmark")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 32, height: 32)
                                            .foregroundColor(.textWhite40)
                                    })
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                        }
                    })
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        HStack(spacing: 6, content: {
                            
                            Icon(image: "info.circle")
                            
                            Text("Hints")
                                .foregroundColor(.white)
                                .font(.system(size: 19, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: {
                                
                                setsModel.hints.append(HintItem(name: ""))
                                
                            }, label: {
                                
                                Image("plus")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.prime)
                            })
                        })
                        
                        ForEach($setsModel.hints) { $index in
                            
                            HStack {
                                
                                ZStack(alignment: .leading) {
                                    
                                    Text("Enter a hint...")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 17, weight: .medium))
                                        .opacity(index.name.isEmpty ? 1 : 0)
                                    
                                    TextField("", text: $index.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 17, weight: .medium))
                                }
                                
                                Spacer()
                                
                                if !index.name.isEmpty && setsModel.hints.count != 1 {
                                    
                                    Button(action: {
                                        
                                        if let index = setsModel.hints.firstIndex(where: { $0.id == index.id }) {
                                            
                                            setsModel.hints.remove(at: index)
                                        }
                                        
                                    }, label: {
                                        
                                        Image("plus")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 32, height: 32)
                                            .foregroundColor(.textWhite40)
                                    })
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                        }
                    })
                }
            }
            .frame(height: UIScreen.main.bounds.height / 1.7)
            
            HStack {
                
                if !(setsModel.selectedSetForEdit == nil) {
                    Button(action: {
                        
                        setsModel.clearData()
                        viewModel.currentStep = .sets
                        
                    }, label: {
                        
                        Text("CANCEL")
                            .font(.body.bold())
                            .foregroundColor(.prime)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.bgButton)
                            .embedInCornRadius(cornradius: 16)
                    })
                    .buttonStyle(ScaledButton(scaling: 0.9))
                }
                
                let isDisSave = setsModel.nameSet.isEmpty || !setsModel.roles.allSatisfy { !$0.name.isEmpty } || !setsModel.locations.allSatisfy { !$0.name.isEmpty }
                    
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
        .sheet(isPresented: $setsModel.isAddPhoto) {
            
            ImagePicker(selectedImage: $setsModel.imageSet)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        NewSet(viewModel: MainViewModel(), setsModel: MainSetsViewModel())
    }
}
