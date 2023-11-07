//
//  User.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation

// An instance of this class should be created for every user, and maintained throughout the lifetime of the app
class User : ObservableObject{
    // TODO: Make static versions of checking if recipe is saved or not by pre-loading the user's saved recipe data
    private var userid : Int
    
    @Published private var localSavedRecipes : [Recipe]
    
    // Most of the database work happens in this class
    private var dbManager : FirebaseManager
    
    init(userID : Int){
        userid = userID
        localSavedRecipes = []
        dbManager = FirebaseManager(userID: String(userid))
        Task(priority: .high){
            let recipes = await dbManager.retrieveSavedRecipes()
            DispatchQueue.main.async { // Ensure the update happens on the main thread
                self.localSavedRecipes = recipes
            }
        }
    }
    
    func getUserID() -> Int{
        return userid
    }
    
    func getSavedRecipes() -> [Recipe]{
        return localSavedRecipes
    }
    
    func isRecipeSaved(recipeID : Int) -> Bool{
        return localSavedRecipes.filter({recipe in recipe.id == recipeID}).count > 0
    }
    
    // REQUIRES: recipe is not currently in the list
    func addSavedRecipe(recipe : Recipe){
        if (isRecipeSaved(recipeID: recipe.id)){
            print("Recipe already added to local version of the list")
            return
        }
        localSavedRecipes.append(recipe)
        dbManager.addRecipeToUser(recipe: recipe)
        
    }
    
    func removeSavedRecipe(recipe : Recipe){
        removeSavedRecipe(recipeID: recipe.id)
    }
    
    func removeSavedRecipe(recipeID : Int){
        if (!isRecipeSaved(recipeID: recipeID)){
            print("Recipe already removed from local version of list")
            return
        }
        localSavedRecipes = localSavedRecipes.filter({$0.id != recipeID})
        dbManager.removeRecipeFromUser(recipeID: recipeID)
        
    }
    
    //TODO: Make future updates/calls to firebase only fire when the user logs out or exits out of the app.
}
