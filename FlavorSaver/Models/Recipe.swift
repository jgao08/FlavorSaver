//
//  Recipe_Info.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/3/23.
//

import Foundation

struct Recipe : Codable, Equatable, Hashable {
    let id : Int
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
        case id
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
    
    func getIngredients() -> [String]{
        return ingredientInfo.map { $0.originalName }
    }
    func getIngredientsWithAmounts() -> [String]{
        return ingredientInfo.map{$0.original}
    }
    
    // TODO: Implement method to get back necessary equipment?
    
    // TODO: Ask the format of this output
    func getRecipeSteps() -> [(String,[String])] {
        var result : [(String,[String])] = []
        
        for ingredientStep in ingredientSteps {
            for step in ingredientStep.steps {
                let stepSentences = step.step
                var stepIngredients : [String] = []
                for ingredient in step.ingredients {
                    stepIngredients.append(ingredient.name)
                }
                result.append((stepSentences, stepIngredients))
            }
        }
        return result
    }
    
    // TODO: Implement these functions if desired from team
    //    func toggleSaved(userID : Int){
    //
    //    }
    //
    //    func isSaved(userID: Int){
    //
    //    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.image == rhs.image &&
        lhs.imageType == rhs.imageType &&
        lhs.servings == rhs.servings &&
        lhs.readyInMinutes == rhs.readyInMinutes &&
        lhs.author == rhs.author &&
        lhs.authorURL == rhs.authorURL &&
        lhs.spoonURL == rhs.spoonURL &&
        lhs.summary == rhs.summary &&
        lhs.cuisines == rhs.cuisines &&
        lhs.dishTypes == rhs.dishTypes
    }
}


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


struct Step_Ingredient : Codable, Hashable {
    let id : Int
    let name : String
    
    enum Coding: String, CodingKey{
        case id
        case name
    }
}

struct Step_Equipment : Codable, Hashable {
    let id : Int
    let name : String
    
    enum Coding: String, CodingKey{
        case id
        case name
    }
}

struct Recipe_Step : Codable, Hashable {
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
struct Recipe_Instructions : Codable, Hashable {
    let name : String
    let steps : [Recipe_Step]
    
    enum CodingKeys: String, CodingKey{
        case name
        case steps
    }
}
