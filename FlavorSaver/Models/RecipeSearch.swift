//
//  RecipeSearch.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/2/23.
//

import Foundation

// Ideally instances of this class are kept in memory so subsequent access to recipes are already retrieved
class RecipeSearch : APIManager{
    var recipe : Recipe
    var recipeInfo : Recipe_Info?
    
    init(_ reci : Recipe){
        recipe = reci
    }
    
    // Retrieves a Recipe_Info struct with the given Recipe from the API call in the form of
    // https://api.spoonacular.com/recipes/RECIPE_ID/information?apiKey=APIKEY

    func getRecipeInfo(completion : @escaping (Recipe_Info) -> Void) {
        if (recipeInfo != nil){
            completion(recipeInfo!)
        }else{
            let apiKey = getAPIKey()
            let urlRequest = "\(apiLink)\(recipe.id)/information?apiKey=\(apiKey)"
            sendAPIRequest(urlRequest, false, completion: { (result, success) in
                if (success){
                    self.recipeInfo = result as? Recipe_Info
                    completion(self.recipeInfo!)
                }else{
                    // DANGEROUS
                    completion(self.recipeInfo!)
                }
            })
        }
    }
    
}
