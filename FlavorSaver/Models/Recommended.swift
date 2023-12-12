//
//  Recommended.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 12/4/23.
//

import Foundation
import FirebaseFirestore

class Recommended : ObservableObject{
    @Published private var recommendedRecipes : [Recipe] = []
    private var apiManager = APIManager()
    
    init(){
        Task(priority: .high){
            await executeRandomSearch()
        }
    }
    
    init() async {
        await executeRandomSearch()
    }
    
    /// Returns the current list of recommended recipes
    /// - Returns: list of recipes
    func getRecommendedRecipes() -> [Recipe]{
        return recommendedRecipes
    }
    
    /// Executes a request to update the random recommended recipes
    func executeRandomSearch() async {
        print("Executing random search")
        let urlRequest = "\(apiManager.randomSearchParams)"
        do{
            let request = try await apiManager.sendAPIRequest(urlRequest, RandomRecipes.self)
            
            DispatchQueue.main.async{
                self.recommendedRecipes = request.recipes
            }
        }catch{
            if (apiManager.apiVersion == "SPOON_API"){
                apiManager.apiVersion = "SPOON_API2"
                await executeRandomSearch()
            }else if (apiManager.apiVersion == "SPOON_API2"){
                apiManager.apiVersion = "SPOON_API3"
                await executeRandomSearch()
            }else{
                print("Error retrieving the recipes in Search.executeRandomSearch(). Error: \(error)")
            }
        }
    }
}

