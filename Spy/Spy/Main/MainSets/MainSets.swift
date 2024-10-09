//
//  MainSets.swift
//  Spy
//
//  Created by Вячеслав on 11/12/23.
//

import SwiftUI
import Amplitude

struct MainSets: View {
    
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
                        
                        viewModel.currentStep = .main
                        
                    }, label: {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("bezhev"))
                            .font(.system(size: 17, weight: .semibold))
                    })
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            if setsModel.isLoading {
                
                ProgressView()
                    .frame(height: UIScreen.main.bounds.height / 2)
                
            } else {
                
                if setsModel.sets.isEmpty {
                    
                    VStack(alignment: .center, spacing: 9, content: {
                        
                        Text("Empty")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                    })
                    .frame(height: UIScreen.main.bounds.height / 2)
                    
                } else {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            
                            ForEach(setsModel.sets, id: \.self) { index in
                            
                                Button(action: {
                                    
                                    viewModel.setSelectedFor = .main
                                    
                                    viewModel.isRandomSet = false
                                    
                                    if viewModel.selectedSet.contains(index) {
                                        
                                        viewModel.selectedSet.removeAll(where: {($0.title ?? "") == index.title})
                                        
                                    } else {
                                        
                                        Amplitude.instance().logEvent("selectSet-\(index.title ?? "nil")")
                                        
                                        viewModel.selectedSet.append(index)
                                    }
                                    
                                }, label: {
                                    
                                    VStack(alignment: .center, spacing: 5, content: {
                                        
                                        if index.coreDataImage == nil {
                                            
                                            Image(systemName: "camera")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 14, weight: .regular))
                                                .frame(height: 100)
                                                .frame(maxWidth: .infinity)
                                                .background(Rectangle().fill(Color.gray.opacity(0.2)).cornerRadius(radius: 7, corners: [.topLeft, .topRight]))
                                            
                                        } else {
                                            
                                            if let coreImage = index.coreDataImage {
                                                
                                                Image(uiImage: coreImage)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 120, height: 120)
                                                    .cornerRadius(radius: 10, corners: [.topRight, .topLeft])
                                                
                                            } else {
                                                
//                                                if let image = index.image {
//                                                    
//                                                    WebPic(urlString: image, width: .infinity, height: 100, cornerRadius: 0, isPlaceholder: true)
//                                                    
//                                                } else {
//                                                    
//                                                    Image(systemName: "camera")
//                                                        .foregroundColor(.gray)
//                                                        .font(.system(size: 14, weight: .regular))
//                                                        .padding(13)
//                                                }
                                            }
                                        }
                                        
                                        VStack(alignment: .center, spacing: 2, content: {
                                            
                                            Text(index.title ?? "nil")
                                                .foregroundColor(.white)
                                                .font(.system(size: 14, weight: .medium))
                                                .multilineTextAlignment(.center)
                                            
                                            Text("\(index.totalLocations ?? 0) \(NSLocalizedString("Cards", comment: ""))")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 12, weight: .regular))
                                        })
                                        .padding(13)
                                    })
                                    .frame(maxWidth: .infinity)
                                    .frame(maxHeight: 230)
                                    .background(RoundedRectangle(cornerRadius: 7).fill(Color("bgGray")))
                                    .overlay (
                                    
                                        HStack {
                                            
                                            if index.image == "" {
                                                
                                                Button(action: {
                                                    
                                                    viewModel.setSelectedFor = .edit
                                                    viewModel.currentStep = .newSet
                                                    
                                                    setsModel.selectedSetForEdit = index
                                                    setsModel.setupEditScreenForEdit()
                                                    
                                                }, label: {
                                                    
                                                    Image(systemName: "square.and.pencil")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 13, weight: .regular))
                                                        .frame(width: 25, height: 25)
                                                        .background(Circle().fill(.black.opacity(0.3)))
                                                })
                                            }
                                            
                                            Spacer()
                                            
                                            Circle()
                                                .fill(viewModel.selectedSet.contains(index) ? Color("primary") : .gray.opacity(0.4))
                                                .frame(width: 16, height: 16)
                                                .overlay (
                                                
                                                    ZStack {
                                                        
                                                        Circle()
                                                            .stroke(viewModel.selectedSet.contains(index) ? .white : .gray.opacity(0.8), lineWidth: 1)
                                                            .frame(width: 16, height: 16)
                                                        
                                                        Image(systemName: "checkmark")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 8, weight: .bold))
                                                            .opacity(viewModel.selectedSet.contains(index) ? 1 : 0)
                                                    }
                                                )
                                        }
                                            .padding(9)
                                            .frame(maxHeight: .infinity, alignment: .top)
                                    )
                                    .overlay (
                                    
                                        RoundedRectangle(cornerRadius: 7)
                                            .stroke(Color("primary"), lineWidth: 1.5)
                                            .opacity(viewModel.selectedSet.contains(index) ? 1 : 0)
                                    )
                                })
                                .buttonStyle(ScaledButton(scaling: 0.9))
                            }
                        }
                        .padding(1)
                    }
                    .frame(height: UIScreen.main.bounds.height / 2)
                }
            }
            
            HStack {
                
                Button(action: {
                    
                    viewModel.currentStep = .newSet
                    
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
                    
                    viewModel.currentStep = .main
                    
                }, label: {
                    
                    Text("SELECT")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [Color("bgRed"), Color("primary")], startPoint: .leading, endPoint: .trailing)))
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .opacity(viewModel.selectedSet.isEmpty ? 0.5 : 1)
                .disabled(viewModel.selectedSet.isEmpty ? true : false)
            }
        }
    }
}

#Preview {
    MainSets(viewModel: MainViewModel(), setsModel: MainSetsViewModel())
}
