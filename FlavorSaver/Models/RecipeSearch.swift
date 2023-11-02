//
//  RecipeSearch.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation


class RecipeSearch{
    var selectedIngredients : [String] = []
    var searchResults : Recipes?
    
    func addIngredient(_ ingredient : String) -> Void {
        if (!selectedIngredients.contains(ingredient)){
            selectedIngredients.append(ingredient)
        }
    }
    func removeIngredient(_ ingredient : String) -> Void {
        selectedIngredients = selectedIngredients.filter({$0 != ingredient})
    }
    
    //    Executes the API call in the form of
    //    https://api.spoonacular.com/recipes/complexSearch?query=QUERY&number=MAXRESULTS&apiKey=APIKEY
    
    func executeSearch(completion : @escaping (Bool) -> Void) -> Void {
        if (selectedIngredients.isEmpty){
            return
        }
        let queryRequest = selectedIngredients.joined(separator: ",")
        
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = dict["SPOON_API"] as? String {
            
            let constants = Constants()
            let urlRequest = "\(constants.apiLink)complexSearch?query=\(queryRequest)&number=\(constants.maxNumberRecipes)&apiKey=\(apiKey)"
            sendAPIRequest(urlRequest, completion)
        } else {
            print("Failed to retrieve API Key from plist")
            return
        }
    }
    
    private func sendAPIRequest(_ url : String, _ completion : @escaping (Bool) -> Void) -> Void{
        let decoder = JSONDecoder()
        if let apiRequest = URL(string: url) {
            let task = URLSession.shared.dataTask(with: apiRequest) { data, response, error in
                if let error = error {
                    print("Error in sending API request: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        self.searchResults = try decoder.decode(Recipes.self, from: data)
                        completion(true)
                    } catch {
                        print("Error in decoding the recipe JSON")
                        completion(false)
                    }
                }
            }
            task.resume()
        } else {
            print("Invalid URL")
        }
        
    }
}
