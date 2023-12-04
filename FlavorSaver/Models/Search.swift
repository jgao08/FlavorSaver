//
//  Search.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation


class Search : ObservableObject{
    
    private var selectedIngredients : [String] = []
    @Published private var searchResults : RecipesMetaData = RecipesMetaData(offset: 0, numberOfRecipes: 0, totalRecipes: 0, recipes: [])
    @Published private var listOfRecipes : [(String,[Recipe])] = []
    @Published private var recommendedRecipes : [Recipe] = []
    
    private var ingredientFinder : Ingredients = Ingredients()
    private var hasChanged : Bool = true
    private var apiManager = APIManager()
    
    init(){
        Task(priority: .high){
            await executeRandomSearch()
        }
    }
    
    
    /// Adds an ingredient to the search request. No ingredients are added if the ingredient is already in the list
    /// - Parameter ingredient: the ingredient to add
    func addIngredient(_ ingredient : String) {
        if (!selectedIngredients.contains(ingredient)){
            selectedIngredients.append(ingredient.lowercased())
            hasChanged = true
        }
    }
    
    /// Removes an ingredient from the search request. No ingredients are removed if the ingredient is not in the list
    /// - Parameter ingredient: ingredient to remove
    func removeIngredient(_ ingredient : String) {
        let newIngredients = selectedIngredients.filter({$0 != ingredient.lowercased()})
        if (newIngredients != selectedIngredients){
            selectedIngredients = newIngredients
            hasChanged = true;
        }
    }
    
    /// Returns the current list of selected ingredients
    /// - Returns: list of ingredients
    func getCurrentSelectedIngredients() -> [String]{
        return selectedIngredients
    }
    
    /// Returns the current list of recommended recipes
    /// - Returns: list of recipes
    func getRecommendedRecipes() -> [Recipe]{
        return recommendedRecipes
    }
    
    /// Returns a list of all recipes returned from the search parameter
    /// - Returns: list of recipes
    func getRecipes() -> [Recipe]{
        return Array(Set(listOfRecipes.flatMap({$1})))
    }
    
    /// Returns a list of tuples representing the (Tag, [Recipes]) of a particular tag
    /// - Returns: list of recipes
    func getRecipesWithTags() -> [(String,[Recipe])]{
        return listOfRecipes
    }
    
    /// Executes a request to update the random recommended recipes
    func executeRandomSearch() async {
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
            }else{
                print("Error retrieving the recipes in Search.executeRandomSearch(). Error: \(error)")
            }
        }
    }
    
    /// Executes the search request and updates the @Published listOfRecipes retrieved from getRecipesWithTags or getRecipes
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
            
            let tagGroups : [(String,[Recipe])] = request.recipes.reduce(into: [:], { (dict, recipe) in
                for tag in recipe.cuisines + recipe.dishTypes{
                    if (dict[tag] == nil){
                        dict[tag] = [recipe]
                    }else{
                        dict[tag]!.append(recipe)
                    }
                }
            }).sorted(by: { (first, second) -> Bool in
                return first.value.count > second.value.count
            }).reduce(into: [], { (list, tuple) in
                list.append((tuple.key, tuple.value))
            })
            
            DispatchQueue.main.async{
                self.searchResults = request
                self.listOfRecipes = tagGroups
            }
            self.hasChanged = false;
        }catch{
            if (apiManager.apiVersion == "SPOON_API"){
                apiManager.apiVersion = "SPOON_API2"
                await executeSearch()
            }else{
                print("Error retrieving the recipes in Search.getRecipes(). Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Retrieves a list of ingredients corresponding to the input search parameter
    /// - Parameter input: search string
    /// - Returns: list of matching ingredients
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

