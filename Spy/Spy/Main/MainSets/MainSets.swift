//
//  MainSets.swift
//  Spy
//
//  Created by Вячеслав on 11/12/23.
//

import SwiftUI
import Amplitude

struct MainSets: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject var setsModel: MainSetsViewModel
    
    @State private var newSet = false
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Color.bgPrime.ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text(NSLocalizedString("Sets", comment: ""))
                        .foregroundColor(.white)
                        .font(.system(size: 19, weight: .bold))
                    
                    HStack {
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            viewModel.currentStep = .main
                            
                        }, label: {
                            Icon(image: "chevron.left")
                        })
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .layoutPriority(1)
                
                VStack {
                    if setsModel.isLoading {
                        
                        ProgressView()
                            .frame(maxHeight: .infinity)
                        //                        .frame(height: UIScreen.main.bounds.height / 2)
                        
                    } else {
                        
                        if setsModel.sets.isEmpty {
                            
                            VStack(alignment: .center, spacing: 9, content: {
                                
                                Text("Empty")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17, weight: .semibold))
                            })
                            .frame(maxHeight: .infinity)
                            
                        } else {
                            
                            VStack(spacing: 0) {
                                
                                HStack {
                                    
                                    Icon(image: "rectangle.stack")
                                    
                                    Text(NSLocalizedString("Use random set(s)", comment: ""))
                                        .foregroundColor(.white)
                                        .font(.system(size: 17, weight: .regular))
                                    
                                    Spacer()
                                    
                                    Toggle(isOn: $viewModel.isRandomSet, label: {})
                                        .toggleStyle(SwitchToggleStyle(tint: Color.prime))
                                }
                                .padding(.horizontal, 12)
                                .frame(height: 60)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                                .onChange(of: viewModel.isRandomSet) { value in
                                    
                                    if value == true {
                                        
                                        viewModel.getRandomSets(sets: setsModel.sets)
                                    }
                                }
                                .padding(.horizontal)
                                
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
                                                .overlay (
                                                    
                                                    HStack {
                                                        
                                                        if index.image == "" {
                                                            
                                                            Button(action: {
                                                                
                                                                viewModel.setSelectedFor = .edit
                                                                viewModel.currentStep = .newSet
                                                                
                                                                setsModel.selectedSetForEdit = index
                                                                setsModel.setupEditScreenForEdit()
                                                                
                                                            }, label: {
                                                                
                                                                Icon(image: "edit circle")
                                                            })
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Icon(image: viewModel.selectedSet.contains(index) ? "check on" : "check off")
                                                    }
                                                        .padding(4)
                                                        .frame(maxHeight: .infinity, alignment: .top)
                                                )
                                                .overlay (
                                                    
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(Color.prime, lineWidth: 2)
                                                        .opacity(viewModel.selectedSet.contains(index) ? 1 : 0)
                                                )
                                            })
                                            .buttonStyle(ScaledButton(scaling: 0.9))
                                        }
                                    }
                                    //                                .padding(1)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    
                                    .padding(.top, 8)
                                }
                                //                            .frame(maxHeight: UIScreen.main.bounds.height / 2)
                                //                            .layoutPriority(0)
                                
                                .disabled(viewModel.isRandomSet)
                                .overlay(
                                    Color.black.opacity(viewModel.isRandomSet ? 0.4 : 0)
                                )
                            }
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height - 205)
                
                HStack {
                    
                    Button(action: {
                        newSet.toggle()
//                        viewModel.currentStep = .newSet
                        
                    }, label: {
                        
                        HStack(spacing: 2) {
                            Image("plus")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color.prime)
                            
                            Text("NEW")
                                .foregroundColor(Color.prime)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .font(.body.bold())
                        .foregroundColor(viewModel.selectedSet.isEmpty ? .textWhite40 : .textWhite)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.bgButton)
                        .embedInCornRadius(cornradius: 16)
                    })
                    
                    NavigationLink(destination: {
                        MainNames()
                            .environmentObject(viewModel)
                            .environmentObject(viewModel.dataManager)
                            .modifier(AnimatedScale())
                            .navigationBarBackButtonHidden()
                        
                    }, label: {
                        
                        Text("NEXT")
                            .font(.body.bold())
                            .foregroundColor(viewModel.selectedSet.isEmpty ? .textWhite40 : .textWhite)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(colors: [viewModel.selectedSet.isEmpty ? Color.bgButtonDisabled : Color.primeTopTrailGrad,
                                                        viewModel.selectedSet.isEmpty ? Color.bgButtonDisabled : Color.primeBotLeadGrad],
                                               startPoint: .topTrailing,
                                               endPoint: .bottomLeading)
                            )
                            .embedInCornRadius(cornradius: 16)
                    })
                    .opacity(viewModel.selectedSet.isEmpty ? 0.5 : 1)
                    .disabled(viewModel.selectedSet.isEmpty ? true : false)
                }
                .padding([.horizontal, .bottom])
                .layoutPriority(1)
            }
            .onAppear {
                
                setsModel.fetchSets()
            }
        }
        .sheet(isPresented: $newSet) {
            NewSet(viewModel: viewModel, setsModel: viewModel.setsModel)
                .modifier(AnimatedScale())
        }
    }
}

#Preview {
    ZStack {
        Color.bgPrime.ignoresSafeArea()
        MainSets()
            .environmentObject(MainViewModel())
            .environmentObject(MainSetsViewModel())
    }
}
