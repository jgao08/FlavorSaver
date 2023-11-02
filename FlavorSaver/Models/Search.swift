//
//  RecipeSearch.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation


class Search : APIManager{
    var selectedIngredients : [String] = []
    var searchResults : Recipes?
    var hasChanged : Bool = true
    
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
                self.searchResults = result as? Recipes
                completion(self.searchResults!.recipes)
            }else{
                completion([])
            }
        })
    }
}
