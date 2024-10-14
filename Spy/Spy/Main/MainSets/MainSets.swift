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
    
    @State private var counterVibro: Int = 0
    
    var isSe: Bool {
        UIScreen.main.bounds.height < 812
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Color.bgPrime.ignoresSafeArea()
            
            VStack {
                if setsModel.isLoading {
                    
                    ProgressView()
                        .frame(maxHeight: .infinity)
                    //                        .frame(height: UIScreen.main.bounds.height / 2)
                    
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            
                            ForEach(setsModel.sets, id: \.self) { index in
                                
                                Button(action: {
                                    counterVibro += 1
                                    
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
                                                    
                                                    newSet.toggle()
                                                }, label: {
                                                    
                                                    Icon(image: "edit circle")
                                                })
//                                                .opacity(0)
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
                        .padding(.top, isSe ? 0 : 34)
                        .padding(.bottom, 100)
                    }
                                                .frame(maxHeight: UIScreen.main.bounds.height - 150)
                    //                            .layoutPriority(0)
                    
                    .disabled(viewModel.isRandomSet)
                    .overlay(
                        Color.black.opacity(viewModel.isRandomSet ? 0.4 : 0)
                    )
                }
            }
//            .frame(height: UIScreen.main.bounds.height - 205)
            .sensoryFeedbackMod(trigger: $counterVibro)
            
            VStack {
                
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
                    
                    if setsModel.sets.isEmpty {
                        
                        VStack(alignment: .center, spacing: 9, content: {
                            
                            Loader(width: 30, height: 30, color: .white)
                                .frame(maxHeight: .infinity, alignment: .center)
                            
//                            Text("Empty")
//                                .foregroundColor(.white)
//                                .font(.system(size: 17, weight: .semibold))
                        })
                        .frame(maxHeight: .infinity)
                        
                    } else {
                        
                        VStack(spacing: 0) {
                            
                            HStack {
                                
                                Icon(image: "rectangle.stack")
                                
                                Text(NSLocalizedString("Use random set(s)", comment: ""))
                                    .foregroundColor(.white)
                                    .font(.system(size: 17, weight: .regular))
                                    .lineLimit(3)
                                    .minimumScaleFactor(0.5)
                                
                                Spacer()
                                
                                Toggle(isOn: $viewModel.isRandomSet, label: {})
                                    .toggleStyle(SwitchToggleStyle(tint: Color.prime))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
                            .onChange(of: viewModel.isRandomSet) { value in
                                
                                if value == true {
                                    
                                    viewModel.getRandomSets(sets: setsModel.sets)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 6)
                .background(Color.bgPrime.edgesIgnoringSafeArea(.top))
                Spacer()
                
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
                .padding(.top, 2)
                .padding([.horizontal, .bottom])
                .background(Color.bgPrime.edgesIgnoringSafeArea(.bottom))
            }
            .frame(height: isSe ? UIScreen.main.bounds.height - 20 : UIScreen.main.bounds.height - 70)
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
