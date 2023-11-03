//
//  RecipeSearch.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation


class Search : APIManager{
    // Currently Selected Ingredients from the user
    private var selectedIngredients : [String] = []
    
    // An instance of the Recipes struct if it has been requested
    var searchResults : Recipes?
    
    // List of the recipes returned from the given search query
    var listOfRecipes : [Recipe_Info] = []
    
    
    private var hasChanged : Bool = true
    
    func addIngredient(_ ingredient : String) -> Void {
        if (!selectedIngredients.contains(ingredient)){
            selectedIngredients.append(ingredient)
            hasChanged = true
        }
    }
    func removeIngredient(_ ingredient : String) -> Void {
        let newIngredients = selectedIngredients.filter({$0 != ingredient})
        if (newIngredients != selectedIngredients){
            selectedIngredients = newIngredients
            hasChanged = true;
        }
    }
    
    //    Executes the API call in the form of
    //    https://api.spoonacular.com/recipes/complexSearch?query=QUERY&number=MAXRESULTS&apiKey=APIKEY
    func getRecipes(completion : @escaping ([Recipe]) -> Void){
        if (!hasChanged){
            return completion(searchResults!.recipes)
        }
        let queryRequest = selectedIngredients.joined(separator: ",")
        let apiKey = getAPIKey()
        let urlRequest = "\(apiKey)complexSearch?query=\(queryRequest)&number=\(maxNumberRecipes)&apiKey=\(apiKey)"
        sendAPIRequest(urlRequest, true, completion: { (result, success) in
            if (success){
                self.hasChanged = false;
                self.searchResults = result as? Recipes
                completion(self.searchResults!.recipes)
            }else{
                completion([])
            }
        })
    }
    
    // TODO: Create function which retrieves list of ingredients from firebase based on given ingredient input (closest match)
    
    // Connecting search results to ingredients
    // list of recipes returned
}
