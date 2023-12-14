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
    private var profileID : Int
    private var dbManager : FirebaseManager
    
    private var savedRecipes : SavedRecipes
    @Published private var savedFolders : [Folder] = []
    @Published private var allSavedRecipes : [Recipe] = []
    
    init(userID : String, username : String, profileID : Int){
        self.userid = userID
        self.username = username
        self.profileID = profileID
        dbManager = FirebaseManager(userID: userID)
        savedRecipes = SavedRecipes(db: dbManager)
        Task(priority: .high){
            savedRecipes = await SavedRecipes(db: dbManager, bool: true)
            DispatchQueue.main.async {
                self.updatePublishedVars()
            }
        }
    }
    
    init(userID : String, username : String){
        self.userid = userID
        self.username = username
        self.profileID = 0
        dbManager = FirebaseManager(userID: userID)
        savedRecipes = SavedRecipes(db: dbManager)
        Task(priority: .high){
            savedRecipes = await SavedRecipes(db: dbManager, bool: true)
            DispatchQueue.main.async {
                self.updatePublishedVars()
            }
        }
        Task(priority: .high){
            self.profileID = await AccountManager.getProfileID(userID: userID)
        }
    }
    
    init(userID : String){
        self.userid = userID
        self.username = ""
        self.profileID = 0
        dbManager = FirebaseManager(userID: userID)
        savedRecipes = SavedRecipes(db: dbManager)
        Task(priority: .high){
            savedRecipes = await SavedRecipes(db: dbManager, bool: true)
            DispatchQueue.main.async {
                self.updatePublishedVars()
            }
        }
        Task(priority: .high){
            self.profileID = await AccountManager.getProfileID(userID: userID)
            self.username = await AccountManager.getUsername(userID: userID)
        }
    }
    
    /// Returns the userID of the user
    /// - Returns: the userID of the user
    func getUserID() -> String{
        return userid
    }
    
    /// Returns the username of the user
    /// - Returns: username
    func getUsername() -> String{
        return username
    }
    
    /// Returns the profileID of the user
    /// - Returns: the profile ID
    func getProfileID() -> Int{
        return profileID
    }
    
    /// Sets the profileID of the user
    /// - Parameter profileID: the profile ID
    func setProfileID(profileID : Int){
        AccountManager.updateProfileID(userID: userid, profileID: profileID)
        self.profileID = profileID
    }
    
    /// Retrieves all saved recipes
    /// - Returns: all saved recipes
    func getSavedRecipes() -> [Recipe]{
        return allSavedRecipes
    }
    
    /// Returns whether a recipe is saved by the user
    /// - Parameter recipeID: recipeID
    /// - Returns: true if the recipe is saved, false if not
    func isRecipeSaved(recipeID : Int) -> Bool{
        return getSavedRecipes().filter({recipe in recipe.id == recipeID}).count > 0
    }
    
    /// Returns whether a recipe is saved by the user in a given folder
    /// - Parameters:
    ///   - recipeID: the recipe ID
    ///   - folderName: the name of the folder
    /// - Returns: true if the recipe is in the folder, false otherwise
    func isRecipeSavedInFolder(recipeID : Int, folderName : String) -> Bool{
        return getSavedRecipes(folderName: folderName).contains(where: {recipe in recipe.id == recipeID})
    }
    
    /// Retrieves the list of saved recipe folders of the user
    /// - Returns: List of folder objects
    func getSavedRecipeFolders() -> [Folder] {
        return savedFolders
    }
    
    /// Adds the given recipe to the given folder
    /// - Parameters:
    ///   - recipe: the recipe to add
    ///   - folder: the folder to add the recipe to
    func addRecipeToFolder(recipe : Recipe, folderName : String){
        savedRecipes.addRecipeToFolder(recipe: recipe, folderName: folderName)
        updatePublishedVars()
    }
    
    /// Removes the given recipe from the given folder
    /// - Parameters:
    ///   - recipe: the recipe to remove
    ///   - folder: the folder to remove the recipe from
    func removeRecipeFromFolder(recipe : Recipe, folderName : String){
        savedRecipes.removeRecipeFromFolder(recipe: recipe, folderName: folderName)
        updatePublishedVars()
    }
    
    /// Attempts to create a new folder of the given name. Returns true if successful, false otherwise. Creating a folder with the same name as an existing folder will fail.
    /// - Parameter name: name of the new folder
    /// - Returns: true if successful, false otherwise
    func createFolder(name : String) -> Bool{
        let status = savedRecipes.createFolder(name: name)
        updatePublishedVars()
        return status
    }
    
    /// Returns nil if the folder name is valid, otherwise returns an error message
    /// - Parameter name: name of folder
    /// - Returns: nil if the folder name is valid, otherwise returns an error message
    func isFolderValid(name : String) -> String?{
        return savedRecipes.isValidFolderName(name: name)
    }
    
    /// Deletes the folder with the given name. If the folder is "Liked Recipes", then the folder is not deleted.
    /// - Parameter folderName: name of the folder to delete
    func deleteFolder(folderName : String){
        savedRecipes.deleteFolder(folderName: folderName)
        updatePublishedVars()
    }
    
    /// Retrieves the saved recipes from a given folder name
    /// - Parameter folderName: name of the folder
    /// - Returns: list of recipes in that folder
    func getSavedRecipes(folderName : String) -> [Recipe] {
        return savedRecipes.showFolderRecipes(folderName: folderName)
    }
    
    /// Changes the ordering parameter of the folder
    /// - Parameters:
    ///   - folderName: name of the folder
    ///   - ordering: ordering (recent, alphabetical, etc.)
    func changeFolderOrdering(folderName : String, ordering : String){
        savedRecipes.changeFolderOrder(folderName: folderName, order: Ordering.fromString(ordering: ordering))
        updatePublishedVars()
    }
    
    private func updatePublishedVars(){
        savedFolders = savedRecipes.refreshFolders()
        allSavedRecipes = savedRecipes.getAllRecipes()
    }
}
