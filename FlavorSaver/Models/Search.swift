//
//  Search.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation


class Search : ObservableObject{
    // Currently Selected Ingredients from the user
    private var selectedIngredients : [String] = []
    
    // An instance of the Recipes struct if it has been requested
    @Published private var searchResults : RecipesMetaData = RecipesMetaData(offset: 0, numberOfRecipes: 0, totalRecipes: 0, recipes: [])
    
    // List of the recipes returned from the given search query
    @Published private var listOfRecipes : [[Recipe]] = []
    
    private var ingredientFinder : Ingredients = Ingredients()
    private var hasChanged : Bool = true
    private var apiManager = APIManager()
    
    // Add an ingredient to the search request
    func addIngredient(_ ingredient : String) -> Void {
        if (!selectedIngredients.contains(ingredient)){
            selectedIngredients.append(ingredient.lowercased())
            hasChanged = true
        }
    }
    
    // Remove an ingredient from the search request
    func removeIngredient(_ ingredient : String) -> Void {
        let newIngredients = selectedIngredients.filter({$0 != ingredient.lowercased()})
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
        return listOfRecipes[0]
    }
    
    func getQuickRecipes() -> [Recipe]{
        return listOfRecipes[0]
    }
    
    func getModerateRecipes() -> [Recipe]{
        return listOfRecipes[1]
    }
    
    func getLongRecipes() -> [Recipe]{
        return listOfRecipes[2]
    }
    
    // ASYNC Function. Executes the search
    func executeSearch() async{
        if (!hasChanged){
            return
        }
        let queryRequest : String = selectedIngredients.joined(separator: ",")
        let cuisineRequest : String = selectedIngredients.filter({ingredientFinder.cuisines.contains($0)}).joined(separator: ",")
        let mealTypeRequest : String = selectedIngredients.filter({ingredientFinder.mealTypes.contains($0)}).joined(separator: ",")
                
        let urlRequest = "\(apiManager.complexSearchParams)&query=\(queryRequest)&cuisine=\(cuisineRequest)&type=\(mealTypeRequest)"
        do{
            let request = try await apiManager.sendAPIRequest(urlRequest, RecipesMetaData.self)
            
            let fast = request.recipes.filter({$0.readyInMinutes <= 30})
            let moderate = request.recipes.filter({$0.readyInMinutes > 30 && $0.readyInMinutes <= 60})
            let long = request.recipes.filter({$0.readyInMinutes > 60})
            
            DispatchQueue.main.async{
                self.searchResults = request
                self.listOfRecipes = [fast, moderate, long]
            }
            self.hasChanged = false;
        }catch{
            print("Error retrieving the recipes in Search.getRecipes(). Error: \(error.localizedDescription)")
        }
    }
    
    // Retrieves a list of ingredients corresponding to the input search parameter
    func getIngredientOptions(_ input : String) -> [String] {
        if (input.isEmpty || !input.first!.isLetter){
            return []
        }
        return ingredientFinder.filterIngredients(input.lowercased())
    }
    
    // TESTING FUNCTION. Not needed to be used regularly
    func getMetaData() -> RecipesMetaData {
        return searchResults
    }
}

