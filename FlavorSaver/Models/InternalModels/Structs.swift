//
//  Structs.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/31/23.
//

import Foundation

struct Recipes_MetaData: Codable, Identifiable{
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

// Used in Recipe struct in Recipe.swift
struct Ingredient : Codable, Identifiable, Hashable{
    let id : Int
    let name : String
    let amount : Float
    let original : String
    let originalName : String
    let unit : String
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case amount
        case original
        case originalName
        case unit
    }
    
}

// Used in Recipe struct in Recipe.swift
struct Recipe_Instructions : Codable, Hashable {
    let name : String
    let steps : [Recipe_Step]
    
    enum CodingKeys: String, CodingKey{
        case name
        case steps
    }
}

// Used in Recipe_Instructions
struct Recipe_Step : Codable, Hashable {
    let number : Int
    let step : String
    let ingredients : [Step_Ingredient]
    
    enum CodingKeys: String, CodingKey{
        case number
        case step
        case ingredients
    }
}

// Used in Recipe_Step
struct Step_Ingredient : Codable, Hashable {
    let id : Int
    let name : String
    
    enum Coding: String, CodingKey{
        case id
        case name
    }
}
