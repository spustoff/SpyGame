//
//  MainDesign.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI
import Amplitude

struct MainDesign: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject var setsModel: MainSetsViewModel
    
    var body: some View {
        
        VStack {
            
            Text(NSLocalizedString("Game Options", comment: ""))
                .foregroundColor(.white)
                .font(.system(size: 19, weight: .bold))
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack {
                    
                    playersCountDesign()
                    
                    spiesCountDesign()
                    
                    timerCountDesign()
                    
//                    setsDesign()
                    
                    rolesDesign()
                    
                    roundsCountDesign()
                    
                    hintDesign()
                }
            }
//            .frame(height: UIScreen.main.bounds.height / 2)
            
            NavigationLink(destination: {
                MainSets()
                    .environmentObject(viewModel)
                    .environmentObject(viewModel.setsModel)
                    .modifier(AnimatedScale())
                    .navigationBarBackButtonHidden()
//                    .onAppear {
//                        viewModel.currentStep = .sets
//                    }
//                MainNames(viewModel: viewModel, dataManager: viewModel.dataManager)
//                    .modifier(AnimatedScale())
//                    .navigationBarBackButtonHidden()
//                    .onAppear {
//                        viewModel.currentStep = .names
//                    }
            }, label: {
                PrimeButton(text: NSLocalizedString("NEXT", comment: ""))
            })
//            Button(action: {
//                viewModel.currentStep = .sets
////                viewModel.viewSwitcher(.plus)
//                
//            }, label: {
//                PrimeButton(text: NSLocalizedString("NEXT", comment: ""))
//            })
//            .opacity(viewModel.selectedSet.isEmpty ? 0.5 : 1)
//            .disabled(viewModel.selectedSet.isEmpty ? true : false)
        }
        .background(Color.bgPrime)
    }
    
    @ViewBuilder
    func playersCountDesign() -> some View {
        
        HStack {
            
            Icon(image: "figure.arms.open")
            
            Text("Players")
                .foregroundColor(.textWhite)
                .font(.system(size: 17, weight: .regular))
            
            Spacer()
            
            HStack(spacing: 8) {
                
                Button(action: {
                    
                    viewModel.PlusMinusManage(number: $viewModel.playersCount, minLimit: 3, maxLimit: 10, isPlayerCount: true, buttonType: .minus)
                    
                }, label: {
                    Icon(image: "minus")
                })
                .disabled(viewModel.playersCount == 3)
                .opacity(viewModel.playersCount == 3 ? 0.3 : 1)
                
                TextField("", value: $viewModel.playersCount, formatter: amountFormatter)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .frame(width: 40, height: 32, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.bgCell))
                
                Button(action: {
                    
                    viewModel.PlusMinusManage(number: $viewModel.playersCount, minLimit: 3, maxLimit: 10, isPlayerCount: true, buttonType: .plus)
                    
                }, label: {
                    Icon(image: "plus")
                })
                .disabled(viewModel.playersCount == 10)
                .opacity(viewModel.playersCount == 10 ? 0.3 : 1)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 60)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
    }
    
    @ViewBuilder
    func spiesCountDesign() -> some View {
        
        HStack {
            
            Icon(image: "sunglasses.fill")
            
            Text("Spies")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .regular))
            
            Spacer()
            
            HStack(spacing: 8) {
                
                Button(action: {
                    
                    viewModel.PlusMinusManage(number: $viewModel.spiesCount, minLimit: 1, maxLimit: viewModel.playersCount - 1, buttonType: .minus)
                    
                }, label: {
                    
                    Icon(image: "minus")
                })
                .opacity(viewModel.spiesCount == 1 ? 0.3 : 1)
                .disabled(viewModel.spiesCount == 1)
                
                TextField("", value: $viewModel.spiesCount, formatter: amountFormatter)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .frame(width: 40, height: 32, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.bgCell))
                
                Button(action: {
                    
                    viewModel.PlusMinusManage(number: $viewModel.spiesCount, minLimit: 1, maxLimit: viewModel.playersCount - 1, buttonType: .plus)
                    
                }, label: {
                    
                    Icon(image: "plus")
                })
                .opacity(viewModel.spiesCount == viewModel.playersCount - 1 ? 0.3 : 1)
                .disabled(viewModel.spiesCount == viewModel.playersCount - 1)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 60)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
    }
    
    @ViewBuilder
    func timerCountDesign() -> some View {
        
        HStack {
            
            Icon(image: "clock")
            
            Text("Timer (min)")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .regular))
            
            Spacer()
            
            HStack(spacing: 8) {
                
                Button(action: {
                    
                    viewModel.PlusMinusManage(number: $viewModel.timerCount, minLimit: 1, maxLimit: 15, buttonType: .minus)
                    
                }, label: {
                    Icon(image: "minus")
                })
                .opacity(viewModel.timerCount == 1 ? 0.3 : 1)
                .disabled(viewModel.timerCount == 1)
                
                TextField("", value: $viewModel.timerCount, formatter: amountFormatter)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .frame(width: 40, height: 32, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.bgCell))
                
                Button(action: {
                    
                    viewModel.PlusMinusManage(number: $viewModel.timerCount, minLimit: 3, maxLimit: 10, buttonType: .plus)
                    
                }, label: {
                    Icon(image: "plus")
                })
                .opacity(viewModel.timerCount == 10 ? 0.3 : 1)
                .disabled(viewModel.timerCount == 10)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 60)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
    }
    
//    @ViewBuilder
//    func setsDesign() -> some View {
//
//        VStack(alignment: .leading, spacing: 15, content: {
//
//            Button(action: {
//
//                viewModel.currentStep = .sets
//
//            }, label: {
//
//                HStack {
//
//                    Image("sets.icon")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 22, height: 22)
//
//                    Text("Sets")
//                        .foregroundColor(.white)
//                        .font(.system(size: 16, weight: .regular))
//
//                    Spacer()
//
//                    HStack(spacing: 10) {
//
//                        Text("\(setsModel.sets.count)")
//                            .foregroundColor(.gray)
//                            .font(.system(size: 15, weight: .regular))
//
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(Color("bezhev"))
//                            .font(.system(size: 14, weight: .regular))
//                    }
//                }
//                .padding(.horizontal)
//            })
//            .buttonStyle(ScaledButton(scaling: 0.9))
//
//            if setsModel.sets.isEmpty {
//
//                Loader(width: 30, height: 30, color: .white)
//                    .frame(width: 230, height: 230)
//                    .frame(maxWidth: .infinity, alignment: .center)
//
//            } else {
//
//                ScrollView(.horizontal, showsIndicators: false) {
//
//                    HStack {
//
//                        ForEach(setsModel.sets.prefix(5), id: \.self) { index in
//
//                            Button(action: {
//
//                                viewModel.isRandomSet = false
//
//                                if viewModel.selectedSet.contains(index) {
//
//                                    viewModel.selectedSet.removeAll(where: {($0.title ?? "") == index.title})
//
//                                } else {
//
//                                    Amplitude.instance().logEvent("selectSet-\(index.title ?? "nil")")
//
//                                    viewModel.selectedSet.append(index)
//                                }
//
//                            }, label: {
//
//                                VStack(alignment: .center, content: {
//
//                                    if index.coreDataImage == nil {
//
//                                        Image(systemName: "camera")
//                                            .foregroundColor(.gray)
//                                            .font(.system(size: 14, weight: .regular))
//                                            .frame(width: 140, height: 70)
//                                            .background(Rectangle().fill(Color.gray.opacity(0.2)).cornerRadius(radius: 7, corners: [.topLeft, .topRight]))
//
//                                    } else {
//
//                                        if let coreImage = index.coreDataImage {
//
//                                            Image(uiImage: coreImage)
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 140, height: 90)
//                                                .cornerRadius(radius: 7, corners: [.topRight, .topLeft])
//
//                                        }
//                                    }
//
//                                    Spacer()
//
//                                    VStack(alignment: .center, spacing: 2, content: {
//
//                                        Text(index.title ?? "")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 14, weight: .medium))
//                                            .multilineTextAlignment(.center)
//
//                                        Text("\(index.totalLocations ?? 0) \(NSLocalizedString("Cards", comment: ""))")
//                                            .foregroundColor(.gray)
//                                            .font(.system(size: 12, weight: .regular))
//                                    })
//                                    .padding(13)
//                                })
//                                .frame(width: 140)
//                                .frame(maxHeight: 230)
//                                .background(RoundedRectangle(cornerRadius: 7).fill(Color("bgGray")))
//                                .overlay (
//
//                                    HStack {
//
//                                        Spacer()
//
//                                        Circle()
//                                            .fill(viewModel.selectedSet.contains(index) ? Color("primary") : .gray.opacity(0.4))
//                                            .frame(width: 16, height: 16)
//                                            .overlay (
//
//                                                ZStack {
//
//                                                    Circle()
//                                                        .stroke(viewModel.selectedSet.contains(index) ? .white : .gray.opacity(0.8), lineWidth: 1)
//                                                        .frame(width: 16, height: 16)
//
//                                                    Image(systemName: "checkmark")
//                                                        .foregroundColor(.white)
//                                                        .font(.system(size: 8, weight: .bold))
//                                                        .opacity(viewModel.selectedSet.contains(index) ? 1 : 0)
//                                                }
//                                            )
//                                    }
//                                        .padding(5)
//                                        .frame(maxHeight: .infinity, alignment: .top)
//                                )
//                                .overlay (
//
//                                    RoundedRectangle(cornerRadius: 7)
//                                        .stroke(Color("primary"), lineWidth: 1.5)
//                                        .opacity(viewModel.selectedSet.contains(index) ? 1 : 0)
//                                )
//                            })
//                            .buttonStyle(ScaledButton(scaling: 0.9))
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 1)
//                }
//                .modifier(AnimatedScale())
//            }
//
//            HStack {
//
//                Image("sets.icon")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 22, height: 22)
//
//                Text("Random Set")
//                    .foregroundColor(.white)
//                    .font(.system(size: 16, weight: .regular))
//
//                Spacer()
//
//                Toggle(isOn: $viewModel.isRandomSet, label: {})
//                    .toggleStyle(SwitchToggleStyle(tint: Color("primary")))
//            }
//            .padding(.horizontal)
//            .onChange(of: viewModel.isRandomSet) { value in
//
//                if value == true {
//
//                    viewModel.getRandomSets(sets: setsModel.sets)
//                }
//            }
//        })
//        .padding([.vertical])
//        .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.09)))
//        .onAppear {
//
//            setsModel.fetchSets()
//        }
//    }
    
    @ViewBuilder
    func rolesDesign() -> some View {
        
        HStack {
            
            Icon(image: "person.crop.circle.badge.questionmark")
            
            Text(NSLocalizedString("Roles", comment: ""))
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .regular))
            
            Spacer()
            
            Toggle(isOn: $viewModel.isRoles, label: {})
                .toggleStyle(SwitchToggleStyle(tint: Color.prime))
        }
        .padding(.horizontal, 12)
        .frame(height: 60)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
    }
    
    @ViewBuilder
    func roundsCountDesign() -> some View {
        
        HStack {
            
            Icon(image: "repeat")
            
            Text(NSLocalizedString("Rounds", comment: ""))
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .regular))
            
            Spacer()
            
            HStack(spacing: 8) {
                
                Button(action: {
                    
                    viewModel.PlusMinusManage(number: $viewModel.roundsCount, minLimit: 1, maxLimit: 15, buttonType: .minus)
                    
                }, label: {
                    Icon(image: "minus")
                })
                .opacity(viewModel.roundsCount == 1 ? 0.3 : 1)
                .disabled(viewModel.roundsCount == 1)
                
                TextField("", value: $viewModel.roundsCount, formatter: amountFormatter)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .frame(width: 40, height: 32, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.bgCell))
                
                Button(action: {
                    
                    viewModel.PlusMinusManage(number: $viewModel.roundsCount, minLimit: 3, maxLimit: 10, buttonType: .plus)
                    
                }, label: {
                    Icon(image: "plus")
                })
                .opacity(viewModel.roundsCount == 10 ? 0.3 : 1)
                .disabled(viewModel.roundsCount == 10)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 60)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
    }
    
    @ViewBuilder
    func hintDesign() -> some View {
        
        HStack {
            
            Icon(image: "info.circle")
            
            Text("Hints")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .regular))
            
            Spacer()
            
            Toggle(isOn: $viewModel.isHints, label: {})
                .toggleStyle(SwitchToggleStyle(tint: Color.prime))
        }
        .padding(.horizontal, 12)
        .frame(height: 60)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.bgCell))
    }
}

#Preview {
    MainDesign()
        .environmentObject(MainViewModel())
        .environmentObject(MainSetsViewModel())
}
