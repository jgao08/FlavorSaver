//
//  Structs.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/31/23.
//

import Foundation
import FirebaseDatabaseSwift
import FirebaseFirestore

struct FirebaseFolder : Codable {
    let ordering : String
    let name : String
    let recipeMeta : [String : FirebaseRecipeMeta]
        
    enum CodingKeys: String, CodingKey {
        case ordering
        case name
        case recipeMeta = "recipes"
    }
}

struct FirebaseRecipeMeta : Codable {
    let firstAdded : Timestamp
    let lastInteracted : Timestamp
    let recipeID : String
    
    enum CodingKeys: String, CodingKey {
        case firstAdded
        case lastInteracted
        case recipeID
    }
}

struct RecipeMeta : Hashable {
    var firstAdded : Timestamp
    var lastInteracted : Timestamp
    var recipe : Recipe
    
    func toFirebaseRecipeMeta() -> FirebaseRecipeMeta {
        return FirebaseRecipeMeta(firstAdded: firstAdded, lastInteracted: lastInteracted, recipeID: String(recipe.id))
    }
}

struct RecipesMetaData: Codable, Identifiable{
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
