//
//  Structs.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/31/23.
//

import Foundation

struct Recipe_Lite : Codable, Identifiable{
    let id : Int
    let title : String
    let image : String
    let imageType : String

    enum CodingKeys: String, CodingKey{
        case id
        case title
        case image
        case imageType
    }
}
struct Recipes: Codable, Identifiable{
    let id = UUID()
    let offset : Int
    let numberOfRecipes : Int
    let totalRecipes : Int
    let recipes : [Recipe_Lite]
    
    
    enum CodingKeys: String, CodingKey {
        case offset
        case numberOfRecipes = "number"
        case totalRecipes = "totalResults"
        case recipes = "results"
    }
    
}
