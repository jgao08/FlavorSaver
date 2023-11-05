//
//  RecipeSearch.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/2/23.
//

import Foundation

// Used
class RecipeSearch{
    private var id : Int
    private var recipeInfo : Recipe?
    private var apiManager : APIManager
    
    init(_ recipeID : Int){
        id = recipeID
        apiManager = APIManager()
    }
    
    func setRecipe(_ recipeID : Int){
        id = recipeID
        recipeInfo = nil
    }
    
    func getRecipeID() -> Int{
        return id
    }
    // Retrieves a Recipe_Info struct with the given Recipe from the API call in the form of
    // https://api.spoonacular.com/recipes/RECIPE_ID/information?apiKey=APIKEY

    func getRecipeInfo(completion : @escaping (Recipe) -> Void) {
        if (recipeInfo != nil){
            completion(recipeInfo!)
        }else{
            let apiKey = apiManager.getAPIKey()
            let urlRequest = "\(apiManager.apiLink)\(id)/information?apiKey=\(apiKey)"
            apiManager.sendAPIRequest(urlRequest, Recipe.self, completion: { (result, success) in
                if (success){
                    self.recipeInfo = result
                    completion(result)
                }else{
                    // DANGEROUS
                    completion(self.recipeInfo!)
                }
            })
        }
    }
    
}
