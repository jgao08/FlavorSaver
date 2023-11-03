//
//  RecipeSearch.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation


class Search : APIManager{
    // Currently Selected Ingredients from the user
    var selectedIngredients : [String] = []
    
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
    func getRecipes(completion : @escaping ([Recipe_Info]) -> Void){
        if (!hasChanged){
            return completion(listOfRecipes)
        }
        let queryRequest = selectedIngredients.joined(separator: ",")
        let apiKey = getAPIKey()
        let urlRequest = "\(apiLink)complexSearch?query=\(queryRequest)&number=\(maxNumberRecipes)&apiKey=\(apiKey)"
        sendAPIRequest(urlRequest, Recipes.self, completion: { (recipesRes, success) in
            if (success){
                self.hasChanged = false;
                self.searchResults = recipesRes
                let mappedIDS = recipesRes.recipes.map {
                    String($0.id)
                }
                let joinedIDS = mappedIDS.joined(separator: ",")
                let newUrlRequest = "\(self.apiLink)informationBulk?ids=\(joinedIDS)&=apiKey=\(apiKey)"
                
                self.sendAPIRequest(newUrlRequest, [Recipe_Info].self, completion: { (result, success) in
                    self.listOfRecipes = result
                    completion(self.listOfRecipes)
                })
            }else{
                completion([])
            }
        })
    }
    
    // TODO: Create function which retrieves list of ingredients from firebase based on given ingredient input (closest match)
    
    // Connecting search results to ingredients
    // list of recipes returned
}

