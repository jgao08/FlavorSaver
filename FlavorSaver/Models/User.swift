//
//  User.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation

/// Represents a user of the app. Contains the user's ID, username, and saved recipes.
class User : ObservableObject{
    private var userid : String
    private var username : String
    private var dbManager : FirebaseManager
    
    @Published private var localSavedRecipes : [Recipe]
    @Published private var savedRecipes : SavedRecipes
    
    init(userID : String, username : String){
        self.userid = userID
        self.username = username
        localSavedRecipes = []
        dbManager = FirebaseManager(userID: String(userid))
        savedRecipes = SavedRecipes(db: dbManager)
        Task(priority: .high){
            let recipes = await dbManager.retrieveSavedRecipes()
            DispatchQueue.main.async {
                self.localSavedRecipes = recipes
            }
        }
    }
    
    /// Returns the userID of the user
    /// - Returns: the userID of the user
    func getUserID() -> String{
        return userid
    }
    
    func getUsername() -> String{
        return username
    }
    
    func getSavedRecipes() -> [Recipe]{
        return getSavedRecipes(folderName: "all")
        //return localSavedRecipes
    }
    
    func isRecipeSaved(recipeID : Int) -> Bool{
        return getSavedRecipes().filter({recipe in recipe.id == recipeID}).count > 0
        //return localSavedRecipes.filter({recipe in recipe.id == recipeID}).count > 0
    }
    
    /// Retrieves the list of saved recipe folders of the user
    /// - Returns: List of folder objects
    func getSavedRecipeFolders() -> [Folder] {
        return savedRecipes.folders
    }
    
    /// Adds the given recipe to the given folder
    /// - Parameters:
    ///   - recipe: the recipe to add
    ///   - folder: the folder to add the recipe to
    func addRecipeToFolder(recipe : Recipe, folderName : String){
        savedRecipes.addRecipeToFolder(recipe: recipe, folderName: folderName)
    }
    
    /// Removes the given recipe from the given folder. If the folder is "all", then the recipe is removed from all folders.
    /// - Parameters:
    ///   - recipe: the recipe to remove
    ///   - folder: the folder to remove the recipe from
    func removeRecipeFromFolder(recipe : Recipe, folderName : String){
        savedRecipes.removeRecipeFromFolder(recipe: recipe, folderName: folderName)
    }
    
    /// Attempts to create a new folder of the given name. Returns true if successful, false otherwise. Creating a folder with the same name as an existing folder will fail.
    /// - Parameter name: name of the new folder
    /// - Returns: true if successful, false otherwise
    func createFolder(name : String) -> Bool{
        return savedRecipes.createFolder(name: name)
    }
    
    /// Deletes the folder with the given name. If the folder is "all", then the folder is not deleted.
    /// - Parameter folderName: name of the folder to delete
    func deleteFolder(folderName : String){
        savedRecipes.deleteFolder(folderName: folderName)
    }
    
    func getSavedRecipes(folderName : String) -> [Recipe] {
        return savedRecipes.showFolderRecipes(folderName: folderName)
    }
    
    func changeFolderOrdering(folderName : String, ordering : String){
        savedRecipes.changeFolderOrder(folderName: folderName, order: Ordering.fromString(ordering: ordering))
    }
    
    // REQUIRES: recipe is not currently in the list
    func addSavedRecipe(recipe : Recipe){
        if (isRecipeSaved(recipeID: recipe.id)){
            print("Recipe already added to local version of the list")
            return
        }
        localSavedRecipes.append(recipe)
        Task(priority: .medium){
            await dbManager.addRecipeToUser(recipe: recipe)
        }
        addRecipeToFolder(recipe: recipe, folderName: "all")
    }
    
    func removeSavedRecipe(recipe : Recipe){
        let recipeID = recipe.id
        if (!isRecipeSaved(recipeID: recipeID)){
            print("Recipe already removed from local version of list")
            return
        }
        localSavedRecipes = localSavedRecipes.filter({$0.id != recipeID})
        Task(priority: .medium){
            await dbManager.removeRecipeFromUser(recipeID: recipeID)
        }
        removeRecipeFromFolder(recipe: recipe, folderName: "all")
    }
}
