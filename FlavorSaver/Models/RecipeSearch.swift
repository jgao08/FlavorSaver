//
//  RecipeSearch.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/2/23.
//

import Foundation

// Currently has no use
class RecipeSearch : ObservableObject{
    private var id : Int
    private var recipeInfo : Recipe?
    private var apiManager : APIManager
    
    init(recipeID : Int){
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
    
    // Retrieves a Recipe struct with the given Recipe from the API call in the form of
    // https://api.spoonacular.com/recipes/RECIPE_ID/information?apiKey=APIKEY
    func getRecipeInfo() async -> Recipe {
        if (recipeInfo != nil){
            return recipeInfo!
        }
        let apiKey = apiManager.getAPIKey()
        let urlRequest = "\(apiManager.apiLink)\(id)/information?apiKey=\(apiKey)"
        do{
            let apiResult = try await apiManager.sendAPIRequest(urlRequest, Recipe.self)
            
            self.recipeInfo = apiResult
            return self.recipeInfo!
        } catch{
            return await getRecipeInfo()
        }
        
    }
    
}
