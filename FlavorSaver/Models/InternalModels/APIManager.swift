//
//  APIManager.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/2/23.
//

import Foundation

class APIManager {
    let apiLink : String = "https://api.spoonacular.com/recipes/"
    static var maxNumberRecipes : Int = 5
    
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
    
    func sendAPIRequest<T>(_ url: String, _ type: T.Type) async throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        
        guard let apiRequest = URL(string: url) else {
            throw APIError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: apiRequest)
            let result = try decoder.decode(type, from: data)
            return result
        } catch {
            throw error
        }
    }
}

enum APIError : Error {
    case invalidURL
}
