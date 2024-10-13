//
//  HistoryView.swift
//  Spy
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var mainVM: MainViewModel
    @StateObject var viewModel = HistoryViewModel()
    
    @Binding var isActive: Bool
    
    @Environment(\.presentationMode) var router
    
    var body: some View {
        
        ZStack {
            
            Color.bgPrime.ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("History")
                        .foregroundColor(.textWhite)
                        .font(.system(size: 19, weight: .semibold))
                    
                    HStack {
                        
                        Button(action: {
                            
                            router.wrappedValue.dismiss()
                            
                        }, label: {
                            Icon(image: "chevron.left")
                        })
                        
                        Spacer()
                    }
                }
                .padding([.horizontal, .top])
                .padding(.bottom, 2)
                
                if viewModel.history.isEmpty {
                    
                    VStack(alignment: .center, spacing: 0, content: {
                        
                        Image("clock.arrow.circlepath")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.textWhite40)
                        
                        VStack(alignment: .center, spacing: 2, content: {
                            
                            Text("History is empty")
                                .foregroundColor(.textWhite80)
                                .font(.system(size: 19, weight: .bold))
                                .multilineTextAlignment(.center)
                            
                            Text(NSLocalizedString("You haven't played a game yet, start playing!", comment: ""))
                                .foregroundColor(.textWhite60)
                                .font(.system(size: 17, weight: .regular))
                                .multilineTextAlignment(.center)
                        })
                    })
                    .padding()
                    .frame(maxHeight: .infinity, alignment: .center)
                    .offset(y: -50)
                    
                } else {
                    
                    let groupedGames = groupAndSortGamesByMonth(games: viewModel.history)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        LazyVStack {
//                            
                            ForEach(groupedGames.keys.sorted(by: >), id: \.self) { month in
                                Section(header: Text(month)
                                    .font(.system(size: 19, weight: .bold))
                                    .foregroundColor(.textWhite)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                ) {
                                    ForEach(groupedGames[month] ?? [], id: \.self) { game in
                                        NavigationLink {
                                            HistoryDetail(isActive: $isActive, item: game)
                                                .environmentObject(mainVM)
                                                .navigationBarBackButtonHidden()
                                        } label: {
                                            HistoryRow(item: game)
                                        }
                                    }
                                }
                            }

                            
//                            ForEach(viewModel.history, id: \.self) { index in
//                            
//                                NavigationLink(destination: {
//                                    
//                                    HistoryDetail(item: index)
//                                        .navigationBarBackButtonHidden()
//                                    
//                                }, label: {
//                                    
//                                    HistoryRow(item: index)
//                                })
//                            }
                        }
                        .padding(.top, 14)
                    }
                }
            }
        }
        .onAppear {
            
            viewModel.fetchHistory()
        }
    }
    
    func groupAndSortGamesByMonth(games: [HistoryModel]) -> [String: [HistoryModel]] {
         var groupedGames = [String: [HistoryModel]]()

         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MMMM yyyy" // Формат для отображения месяца и года

         for game in games {
             let month = dateFormatter.string(from: game.gameDate ?? Date())
             if groupedGames[month] != nil {
                 groupedGames[month]?.append(game)
             } else {
                 groupedGames[month] = [game]
             }
         }

         // Сортируем массивы по уменьшению даты
         for (month, games) in groupedGames {
             groupedGames[month] = games.sorted(by: { $0.gameDate ?? Date() > $1.gameDate ?? Date() })
         }

         return groupedGames
     }

}

#Preview {
    HistoryView(isActive: .constant(true))
        .environmentObject(MainViewModel())
}
