//
//  Ext+CoredataStack.swift
//  Spy
//
//  Created by Вячеслав on 11/14/23.
//

import SwiftUI
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private let modelName: String = "CoreSetModel"
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
        
    func saveContext() {
        
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                
                try context.save()
                
            } catch {
                
                let nserror = error as NSError
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllSets() {
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CoreSetModel.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            
            try context.execute(deleteRequest)
            try context.save()
            
        } catch {
            
            let nserror = error as NSError
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteSet(withUniqueID uniqueID: Int64, completion: @escaping () -> (Void)) {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreSetModel> = CoreSetModel.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "idSet == %ld", Int64(uniqueID))
        
        do {
            
            let objects = try context.fetch(fetchRequest)
            
            for object in objects {
                
                context.delete(object)
            }
            
            CoreDataStack.shared.saveContext()
            
            completion()
            
        } catch {
            
            print("Error fetching: \(error)")
        }
    }
}

class MySecureTransformer: NSSecureUnarchiveFromDataTransformer {
    
    override class var allowedTopLevelClasses: [AnyClass] {
        
        return [NSArray.self, NSString.self, NSNumber.self, NSDate.self]
    }
    
    static func register() {
        
        let transformer = MySecureTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName("MySecureTransformer"))
    }
}
