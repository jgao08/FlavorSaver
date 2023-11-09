//
//  Structs.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/31/23.
//

import Foundation

struct RecipesMetaData: Codable, Identifiable{
    let id = UUID()
    let offset : Int
    let numberOfRecipes : Int
    let totalRecipes : Int
    let recipes : [RecipeLite]
    
    
    enum CodingKeys: String, CodingKey {
        case offset
        case numberOfRecipes = "number"
        case totalRecipes = "totalResults"
        case recipes = "results"
    }
}

struct RecipeLite : Codable, Identifiable{
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
struct RecipeInstructions : Codable, Hashable {
    let name : String
    let steps : [RecipeStep]
    
    enum CodingKeys: String, CodingKey{
        case name
        case steps
    }
}

// Used in RecipeInstructions
struct RecipeStep : Codable, Hashable {
    let number : Int
    let step : String
    let ingredients : [StepIngredient]
    
    enum CodingKeys: String, CodingKey{
        case number
        case step
        case ingredients
    }
}

// Used in RecipeStep
struct StepIngredient : Codable, Hashable {
    let id : Int
    let name : String
    
    enum Coding: String, CodingKey{
        case id
        case name
    }
}
