//
//  MainSetsModel.swift
//  Spy
//
//  Created by Вячеслав on 11/13/23.
//

import SwiftUI
import Foundation

struct ResponseData: Codable, Hashable {
    
    var error: Bool?
    var messages: [String]?
    var data: [SetModel]?
}

struct SetModel: Codable, Hashable {
    
    var id: Int?
    var title: String?
    var image: String?
    var coreDataImage: UIImage?
    var isPremium: Bool?
    var totalLocations: Int?
    var locations: [Location]?
    var roles: [String]?

    enum CodingKeys: String, CodingKey {
        
        case id, title, image, locations, roles
        case isPremium = "is_premium"
        case totalLocations = "totalLocations"
    }
}

struct Location: Codable, Hashable {
    
    var id: Int?
    var location: String?
    var hints: [String]?
}

struct RoleItem: Identifiable {
    
    let id = UUID()
    var name: String
}

struct LocationItem: Identifiable {
    
    let id = UUID()
    var name: String
}

struct HintItem: Identifiable {
    
    let id = UUID()
    var name: String
}
