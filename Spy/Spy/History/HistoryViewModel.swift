//
//  HistoryViewModel.swift
//  Spy
//
//  Created by Вячеслав on 11/25/23.
//

import SwiftUI
import CoreData

final class HistoryViewModel: ObservableObject {
    
    @Published var history: [HistoryModel] = []
    @Published var isReviewView: Bool = false
    @AppStorage("isReviewedAlready") var isReviewedAlready: Bool = false
    
    func fetchHistory() {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<HistoryModel>(entityName: "HistoryModel")

        let sortDescriptor = NSSortDescriptor(key: "gameDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            
            let historyModels = try context.fetch(fetchRequest)
            
            self.history = historyModels
            
        } catch let error as NSError {
            
            print("Error fetching history: \(error), \(error.userInfo)")
            
            self.history = []
        }
    }
}
