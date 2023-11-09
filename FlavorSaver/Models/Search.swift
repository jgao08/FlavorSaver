//
//  RecipeSearch.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation


class Search : ObservableObject{
    // Currently Selected Ingredients from the user
    private var selectedIngredients : [String] = []
    
    // An instance of the Recipes struct if it has been requested
    private var searchResults : RecipesMetaData?
    
    // List of the recipes returned from the given search query
    @Published private var listOfRecipes : [Recipe] = []
    
    private var ingredientFinder : Ingredients = Ingredients()
    private var hasChanged : Bool = true
    private var apiManager = APIManager()
    
    // Add an ingredient to the search request
    func addIngredient(_ ingredient : String) -> Void {
        if (!selectedIngredients.contains(ingredient)){
            selectedIngredients.append(ingredient)
            hasChanged = true
        }
    }
    
    // Remove an ingredient from the search request
    func removeIngredient(_ ingredient : String) -> Void {
        let newIngredients = selectedIngredients.filter({$0 != ingredient})
        if (newIngredients != selectedIngredients){
            selectedIngredients = newIngredients
            hasChanged = true;
        }
    }
    
    // Get back to current list of selected ingredients
    func getCurrentSelectedIngredients() -> [String]{
        return selectedIngredients
    }
    
    // Retrieves a list of the recipes from the given search parameter
    func getRecipes() -> [Recipe]{
        return listOfRecipes
    }
    
    // ASYNC Function. Executes the search
    func executeSearch() async{
        if (!hasChanged){
            return
        }
        let queryRequest = selectedIngredients.joined(separator: ",")
        let apiKey = apiManager.getAPIKey()
        let urlRequest = "\(apiManager.apiLink)complexSearch?query=\(queryRequest)&number=\(APIManager.maxNumberRecipes)&apiKey=\(apiKey)"
        
        do{
            let request = try await apiManager.sendAPIRequest(urlRequest, RecipesMetaData.self)
            self.searchResults = request
            let mappedIDS = request.recipes.map {String($0.id)}
            let joinedIDS = mappedIDS.joined(separator: ",")
            let newUrlRequest = "\(self.apiManager.apiLink)informationBulk?ids=\(joinedIDS)&apiKey=\(apiKey)"
            
            let bulkRequest = try await apiManager.sendAPIRequest(newUrlRequest, [Recipe].self)
            DispatchQueue.main.async {
                self.listOfRecipes = bulkRequest
            }
            self.hasChanged = false;
        }catch{
            print("Error retrieving the recipes in Search.getRecipes(). Error: \(error.localizedDescription)")
        }
    }
    
    // Retrieves a list of ingredients corresponding to the input search parameter
    func getIngredientOptions(_ input : String) -> [String] {
        if (input.isEmpty || !input.first!.isASCII){
            return []
        }
        return ingredientFinder.filterIngredients(input.lowercased())
    }
    
    // TESTING FUNCTION. Not needed to be used regularly
    func getMetaData() -> RecipesMetaData {
        return searchResults!
    }
}

