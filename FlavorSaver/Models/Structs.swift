//
//  Structs.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/31/23.
//

import Foundation

struct Ingredient : Codable, Identifiable{
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


struct Step_Ingredient : Codable {
    let id : Int
    let name : String
    
    enum Coding: String, CodingKey{
        case id
        case name
    }
}

struct Step_Equipment : Codable {
    let id : Int
    let name : String
    
    enum Coding: String, CodingKey{
        case id
        case name
    }
}

struct Recipe_Step : Codable{
    let number : Int
    let step : String
    let ingredients : [Step_Ingredient]
    let equipment : [Step_Equipment]
    
    enum CodingKeys: String, CodingKey{
        case number
        case step
        case ingredients
        case equipment
    }
}
struct Recipe_Instructions : Codable{
    let name : String
    let steps : [Recipe_Step]
    
    enum CodingKeys: String, CodingKey{
        case name
        case steps
    }
}



struct Recipe_Info : Codable{
    let name : String
    let image : String
    let imageType : String
    
    let servings : Int
    let readyInMinutes : Int
    let author : String
    let authorURL : String
    let spoonURL : String
    let summary : String
    
    let cuisines : [String]
    let dishTypes : [String]
    let ingredientInfo : [Ingredient]
    let ingredientSteps : [Recipe_Instructions]
    
    enum CodingKeys: String, CodingKey{
        case name = "title"
        case image
        case imageType
        case servings
        case readyInMinutes
        case author = "sourceName"
        case authorURL = "sourceUrl"
        case spoonURL = "spoonacularSourceUrl"
        case summary
        case cuisines
        case dishTypes
        case ingredientInfo = "extendedIngredients"
        case ingredientSteps = "analyzedInstructions"
    }
}

struct Recipe : Codable, Identifiable{
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
    let recipes : [Recipe]
    
    
    enum CodingKeys: String, CodingKey {
        case offset
        case numberOfRecipes = "number"
        case totalRecipes = "totalResults"
        case recipes = "results"
    }
    
}
