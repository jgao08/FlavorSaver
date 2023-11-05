//
//  RecipeSearch.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation


class Search{
    // Currently Selected Ingredients from the user
    var selectedIngredients : [String] = []
    
    // An instance of the Recipes struct if it has been requested
    var searchResults : Recipes?
    
    // List of the recipes returned from the given search query
    var listOfRecipes : [Recipe] = []
    
    private var ingredientFinder : Ingredients = Ingredients()
    private var hasChanged : Bool = true
    private var apiManager = APIManager()
    
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
            return completion(listOfRecipes)
        }
        let queryRequest = selectedIngredients.joined(separator: ",")
        let apiKey = apiManager.getAPIKey()
        let urlRequest = "\(apiManager.apiLink)complexSearch?query=\(queryRequest)&number=\(APIManager.maxNumberRecipes)&apiKey=\(apiKey)"
        apiManager.sendAPIRequest(urlRequest, Recipes.self, completion: { (recipesRes, success) in
            if (success){
                self.hasChanged = false;
                self.searchResults = recipesRes
                let mappedIDS = recipesRes.recipes.map {
                    String($0.id)
                }
                let joinedIDS = mappedIDS.joined(separator: ",")
                let newUrlRequest = "\(self.apiManager.apiLink)informationBulk?ids=\(joinedIDS)&apiKey=\(apiKey)"
                
                self.apiManager.sendAPIRequest(newUrlRequest, [Recipe].self, completion: { (result, success) in
                    self.listOfRecipes = result
                    completion(self.listOfRecipes)
                })
            }else{
                completion([])
            }
        })
    }
    
    func getIngredients(_ input : String) -> [String] {
        if (input.isEmpty){
            return []
        }
        return ingredientFinder.filterIngredients(input)
    }
}

