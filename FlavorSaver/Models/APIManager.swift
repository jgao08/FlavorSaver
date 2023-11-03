//
//  APIManager.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/2/23.
//

import Foundation

class APIManager {
    let apiLink : String = "https://api.spoonacular.com/recipes/"
    let maxNumberRecipes : Int = 30
    
    func getAPIKey() -> String {
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = dict["SPOON_API"] as? String {
            
            return apiKey
        } else {
            print("Failed to retrieve API Key from plist")
            return ""
        }
    }
    
    func sendAPIRequest(_ url : String, _ type : Bool, completion : @escaping ((Any,Bool)) -> Void){
        let decoder = JSONDecoder()

        if let apiRequest = URL(string: url) {
            let task = URLSession.shared.dataTask(with: apiRequest) { data, response, error in
                if let error = error {
                    print("Error in sending API request: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        if (type){
                            let result = try decoder.decode(Recipes.self, from: data)
                            completion((result, true))
                        }else{
                            let result = try decoder.decode(Recipe_Info.self, from: data)
                            completion((result, true))
                        }
                    } catch {
                        print("Error in decoding the recipe JSON")
                        completion((data, false))
                    }
                }
            }
            task.resume()
        } else {
            print("Invalid URL")
        }
        
    }
}
