//
//  Recipe_Info.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/3/23.
//

import Foundation

struct Recipe : Codable, Equatable, Hashable, Identifiable {
    
    /// Retrieves the ingredients with just their name (without amounts)
    /// - Returns: list of ingredients
    func getIngredients() -> [String]{
        return ingredientInfo.map{$0.originalName}
    }
    
    /// Retrieves the ingredients of the recipe with their corresponding amounts
    /// - Returns: list of ingredients
    func getIngredientsWithAmounts() -> [String]{
        return ingredientInfo.map{$0.original}
    }
    
    /// Returns a list of tuples representing the (Instruction, [Ingredients]) of a particular step
    /// - Returns: returns a list of tuples representing the (Instruction, [Ingredients]) of a particular step
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
    
    /// Returns a list of tuples representing the (Index, Instruction, [Ingredients]) of a particular step
    /// - Returns: list of tuples representing the (Index, Instruction, [Ingredients]) of a particular step
    func getRecipeStepsWithAmounts() -> [(Int, String,[String])] {
        var result : [(Int, String,[String])] = []
        let ingredientsWithAmounts = getIngredientsWithAmounts()
        var stepIndex: Int = 1
        
        for ingredientStep in ingredientSteps {
            for step in ingredientStep.steps {
                let stepSentences = step.step
                var stepIngredients : [String] = []
                for ingredient in step.ingredients {
                    if let ingredientWithAmount: String = ingredientsWithAmounts.filter({ $0.lowercased().contains(ingredient.name.lowercased())}).first {
                        stepIngredients.append(ingredientWithAmount)
                    }
                }
                result.append((stepIndex, stepSentences, stepIngredients))
                stepIndex += 1
            }
        }
        return result
    }
    
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
    let ingredientSteps : [RecipeInstructions]
    
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
