//
//  MainSetsViewModel.swift
//  Spy
//
//  Created by Вячеслав on 11/13/23.
//

import SwiftUI
import Alamofire
import CoreData

final class MainSetsViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var isAddPhoto: Bool = false
    
    @Published var sets: [SetModel] = []
    @Published var coreDataSets: [CoreSetModel] = []
    
    @Published var imageSet: UIImage? = nil
    @Published var nameSet: String = ""
    @Published var roles: [RoleItem] = [RoleItem(name: "")]
    @Published var locations: [LocationItem] = [LocationItem(name: "")]
    @Published var hints: [HintItem] = [HintItem(name: "")]
    
    @Published var isServerFetched: Bool = false
    @Published var isCoreDataFetched: Bool = false
    
    // MARK: -- EDIT CUSTOM SET
    @Published var selectedSetForEdit: SetModel? = nil
    
    func setupEditScreenForEdit() {
        
        let set = selectedSetForEdit
        
        print(set?.id ?? 0)
        
        nameSet = set?.title ?? ""
        imageSet = set?.coreDataImage
        
        if let rolesArray = set?.roles {
            
            let roleItems = rolesArray.compactMap { RoleItem(name: $0) }
            
            roles = roleItems
        }
        
        if let locationsArray = set?.locations {
            
            let locationItems = locationsArray.compactMap { location -> LocationItem? in
                
                guard let name = location.location else { return nil }
                
                return LocationItem(name: name)
            }
            
            locations = locationItems
        }
    }
    
    func convertCoreDataToModel(coreSetModel: CoreSetModel) -> SetModel {
        
        let decoder = SharedDataManager.shared.jsonDecoder
        
        let roles: [String]? = try? decoder.decode([String].self, from: coreSetModel.roles as? Data ?? Data())
        let locationsStrings: [String] = (try? decoder.decode([String].self, from: coreSetModel.locations as? Data ?? Data())) ?? []
        let hintsStrings: [String] = (try? decoder.decode([String].self, from: coreSetModel.hints as? Data ?? Data())) ?? []
        
        let locationsArray = locationsStrings.map { locationString -> Location in
            
            return Location(id: Int.random(in: 1...999999), location: locationString, hints: hintsStrings)
        }
        
        var resizedImage: UIImage? = nil

        if let image = UIImage(data: coreSetModel.imageSet ?? Data()) {
            
            resizedImage = resizeImage(image: image, targetSize: CGSize(width: 250, height: 250))
        }
        
        return SetModel(
            id: Int(coreSetModel.idSet),
            title: coreSetModel.nameSet,
            image: "",
            coreDataImage: resizedImage,
            isPremium: coreSetModel.isPremium,
            totalLocations: Int(coreSetModel.totalLocations),
            locations: locationsArray,
            roles: roles
        )
    }

    func fetchCoreSets() {
        
        guard !isCoreDataFetched else { return }
        
        isCoreDataFetched = true
        
        print("fetch coredata")
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoreSetModel>(entityName: "CoreSetModel")

        do {
            
            let coreDataSets = try context.fetch(fetchRequest)
        
            DispatchQueue.main.async {
                
                self.sets = coreDataSets.map(self.convertCoreDataToModel)
            }
            
        } catch let error as NSError {
            
            print("catch")
            
            print("Error fetching persons: \(error), \(error.userInfo)")
            
            self.sets = []
        }
    }
    
    func clearData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.imageSet = nil
            self.nameSet = ""
            self.roles = [RoleItem(name: "")]
            self.locations = [LocationItem(name: "")]
            self.hints = [HintItem(name: "")]
            self.selectedSetForEdit = nil
        }
    }
    
    func addSet(completion: @escaping () -> (Void)) {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let set = NSEntityDescription.insertNewObject(forEntityName: "CoreSetModel", into: context) as! CoreSetModel
        
        let encoder = JSONEncoder()
        
        if let encodedRoles = try? encoder.encode(roles.map(\.name)), let encodedLocations = try? encoder.encode(locations.map(\.name)), let encodedHints = try? encoder.encode(hints.map(\.name)) {
            
            set.roles = encodedRoles as NSObject
            set.locations = encodedLocations as NSObject
            set.hints = encodedHints as NSObject
        }
        
        set.isPremium = false
        set.idSet = Int64.random(in: 1...99999)
        set.totalLocations = Int16(locations.count)
        set.nameSet = nameSet

        if let imageData = imageSet?.pngData() {
            
            set.imageSet = imageData
        }
        
        CoreDataStack.shared.saveContext()
        
        completion()
    }
    
    func updateSet(completion: @escaping () -> Void) {
        guard let withId = selectedSetForEdit?.id else { return }
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreSetModel> = CoreSetModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idSet == %d", withId)

        do {
            let results = try context.fetch(fetchRequest)
            if let setToUpdate = results.first {
                let encoder = JSONEncoder()

                if let encodedRoles = try? encoder.encode(roles.map(\.name)),
                   let encodedLocations = try? encoder.encode(locations.map(\.name)),
                   let encodedHints = try? encoder.encode(hints.map(\.name)) {

                    setToUpdate.roles = encodedRoles as NSObject
                    setToUpdate.locations = encodedLocations as NSObject
                    setToUpdate.hints = encodedHints as NSObject
                }

                setToUpdate.isLocallyModified = true
                setToUpdate.isPremium = false // Возможно, вам нужно обновить это значение, если оно меняется
                setToUpdate.totalLocations = Int16(locations.count)
                setToUpdate.nameSet = nameSet

                if let imageData = imageSet?.pngData() {
                    setToUpdate.imageSet = imageData
                }

                CoreDataStack.shared.saveContext()
                
                completion()
            } else {
                print("Не удалось найти сет с id \(withId)")
            }
        } catch let error as NSError {
            print("Ошибка при обновлении сета: \(error), \(error.userInfo)")
        }
    }

    
    func fetchSets() {
        guard !isServerFetched else { return }
        
        isServerFetched = true
        
        print("fetch server")
        
        isLoading = true
        
        let parameters: [String: Any] = [
            "token": "2ec61a22-855a-4f00-a561-5f2b6447653e",
            "lang": Locale.current.languageCode ?? "en"
        ]
        
        AF.request("https://spapppro.site/api/fetch/sets", method: .get, parameters: parameters, encoding: URLEncoding.default).responseDecodable(of: ResponseData.self) { [weak self] response in
            switch response.result {
            case .success(let success):
                guard let newSets = success.data else { return }
                self?.updateCoreData(with: newSets)
                
            case .failure(let failure):
                self?.isCoreDataFetched = false
                self?.fetchCoreSets()
            }
            self?.isLoading = false
        }
    }
    
    private func updateCoreData(with newSets: [SetModel]) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreSetModel> = CoreSetModel.fetchRequest()

        let group = DispatchGroup()

        do {
            let existingSets = try context.fetch(fetchRequest)
            var updates = [(CoreSetModel, SetModel)]()

            for newSet in newSets {
                if let existingSet = existingSets.first(where: { $0.idSet == newSet.id ?? 0 }) {
                    if !existingSet.isLocallyModified {
                        updates.append((existingSet, newSet))
                    }
                } else {
                    let newCoreSet = convertSetModelToCoreData(newSet, coreDataImage: nil, context: context)
                    // Запланировать загрузку и обновление изображения для новой записи
                    if let imageUrl = newSet.image, !imageUrl.isEmpty {
                        group.enter()
                        loadImage(from: imageUrl) { [weak self] downloadedImage in
                            self?.updateImageForSet(withId: Int(newCoreSet.idSet), image: downloadedImage) {
                                group.leave()
                            }
                        }
                    }
                }
            }

            for (existingSet, newSet) in updates {
                updateSetModel(existingSet, withNewSet: newSet, coreDataImage: nil)
            }

            CoreDataStack.shared.saveContext()

            // Вызываем fetchCoreSets после завершения всех загрузок
            group.notify(queue: .main) {
                self.isCoreDataFetched = false
                self.fetchCoreSets()
            }
            
        } catch let error as NSError {
            print("Ошибка при обновлении CoreData: \(error), \(error.userInfo)")
        }
    }
    
    private func updateImageForSet(withId id: Int?, image: UIImage?, completion: @escaping () -> Void) {
        guard let id = id else { return }
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreSetModel> = CoreSetModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idSet == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let setToUpdate = results.first {
                if let imageData = image?.pngData() {
                    setToUpdate.imageSet = imageData
                }
                CoreDataStack.shared.saveContext()
                //                self.isCoreDataFetched = false
                //                fetchCoreSets()
            }
        } catch let error as NSError {
            print("Ошибка при обновлении изображения в CoreData: \(error), \(error.userInfo)")
        }
        completion()
    }

    private func convertSetModelToCoreData(_ setModel: SetModel, coreDataImage: UIImage?, context: NSManagedObjectContext) -> CoreSetModel {
        let coreSetModel = NSEntityDescription.insertNewObject(forEntityName: "CoreSetModel", into: context) as! CoreSetModel
        
        coreSetModel.idSet = Int64(setModel.id ?? 0)
        coreSetModel.nameSet = setModel.title ?? ""
        coreSetModel.isPremium = setModel.isPremium ?? false
        coreSetModel.totalLocations = Int16(setModel.totalLocations ?? 0)

        let encoder = JSONEncoder()
        if let encodedRoles = try? encoder.encode(setModel.roles) {
            coreSetModel.roles = NSData(data: encodedRoles)
        }
        
        if let locationStrings = setModel.locations?.map(\.location),
           let encodedLocations = try? encoder.encode(locationStrings) {
            coreSetModel.locations = NSData(data: encodedLocations)
        }
        
        if let imageData = coreDataImage?.pngData() {
            coreSetModel.imageSet = imageData
        }

        return coreSetModel
    }
    
    private func updateSetModel(_ coreSetModel: CoreSetModel, withNewSet newSet: SetModel, coreDataImage: UIImage?) {
        coreSetModel.nameSet = newSet.title ?? ""
        coreSetModel.isPremium = newSet.isPremium ?? false
        coreSetModel.totalLocations = Int16(newSet.totalLocations ?? 0)


        let encoder = SharedDataManager.shared.jsonEncoder
        if let encodedRoles = try? encoder.encode(newSet.roles) {
            coreSetModel.roles = NSData(data: encodedRoles)
        }
        
        if let locationStrings = newSet.locations?.map(\.location),
           let encodedLocations = try? encoder.encode(locationStrings) {
            coreSetModel.locations = NSData(data: encodedLocations)
        }

        if let imageData = coreDataImage?.pngData() {
            coreSetModel.imageSet = imageData
        }
    }
    
    private func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}

class SharedDataManager {
    
    static let shared = SharedDataManager()
    
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()

    private init() {}
}
