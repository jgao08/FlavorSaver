//
//  APIManager.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/2/23.
//

import Foundation

class APIManager {
    let apiLink : String = "https://api.spoonacular.com/recipes/"
    let maxNumberRecipes : Int = 5
    
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
    
    func sendAPIRequest<T>(_ url : String, _ type : T.Type, completion : @escaping ((T,Bool)) -> Void) where T : Decodable{
        let decoder = JSONDecoder()

        if let apiRequest = URL(string: url) {
            let task = URLSession.shared.dataTask(with: apiRequest) { data, response, error in
                if let error = error {
                    print("Error in sending API request: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let result = try decoder.decode(type, from: data)
                        completion((result, true))
                        
                    } catch {
                        print("Error in decoding the recipe JSON")
                        // DANGEROUS
                        completion((data as! T, false))
                    }
                }
            }
            task.resume()
        } else {
            print("Invalid URL")
        }
        
    }
}
