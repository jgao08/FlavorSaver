//
//  SavedRecipes.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/16/23.
//

import Foundation
import FirebaseDatabaseSwift
import FirebaseFirestore

class Folder : ObservableObject, Equatable {
    var ordering : Ordering = .recent
    var name : String
    @Published var recipeMeta : [RecipeMeta] = []
    @Published var recipes : [Recipe] = []
    
    init(name: String) {
        self.name = name
    }
    init(recipeMeta : [RecipeMeta], ordering : Ordering, name : String) {
        self.recipeMeta = recipeMeta
        self.ordering = ordering
        self.name = name
    }
    
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        return lhs.name == rhs.name
    }
    
    func recipeMetaToRecipe() -> [Recipe] {
        return recipeMeta.map({meta in meta.recipe})
    }
}

class SavedRecipes : ObservableObject {
    @Published var folders : [Folder] = []
    
    let dbManager : FirebaseManager
    
    init(db : FirebaseManager){
        dbManager = db
        Task(priority: .high){
            let folders = await db.retrieveSavedFolders()
            DispatchQueue.main.async {
                self.folders = folders
            }
        }
    }
    
    private func getFolder(name : String) -> Folder? {
        return folders.filter({folder in folder.name == name}).first
    }
    
    ///  Retrieves the recipes in the given folder
    /// - Parameter folderName: the folder to retrieve the recipes of
    /// - Returns: the recipes in the folder
    func showFolderRecipes(folderName : String) -> [Recipe]{
        guard let folder = getFolder(name: folderName) else {
            return []
        }
        return enforceInvariants(folder: folder)
    }
    
    /// Enforces the invariants of the given folder, specifically its ordering status and removes duplicates
    /// - Parameter folder: the folder to enforce the invariants of
    /// - Returns: the recipes sorted according to the folder's ordering
    private func enforceInvariants(folder : Folder) -> [Recipe] {
        let ordering = folder.ordering
        var recipes = Array(Set(folder.recipeMeta))
        
        switch ordering {
        case .alphabetical:
            recipes = recipes.sorted(by: {$0.recipe.name > $1.recipe.name})
        case .alphabeticalReverse:
            recipes = recipes.sorted(by: {$0.recipe.name < $1.recipe.name})
        case .recent:
            recipes = recipes.sorted(by: {$0.firstAdded.seconds < $1.firstAdded.seconds})
        default:
            recipes = recipes.sorted(by: {$0.firstAdded.seconds > $1.firstAdded.seconds})
        }
    
        return recipes.map({meta in meta.recipe})
    }
    
    /// Changes the ordering of the given folder
    /// - Parameters:
    ///   - folder: the folder to change the ordering of
    ///   - order: the new ordering of the folder
    func changeFolderOrder(folderName : String, order : Ordering){
        guard let folder = getFolder(name: folderName) else {
            print("Foldename is not valid")
            return
        }
        folder.ordering = order
        folder.recipes = enforceInvariants(folder: folder)
        Task(priority: .high){
            await dbManager.updateFolders(folders: folders)
        }
    }
    
    
    /// Adds a recipe to the given folder.
    /// - Parameters:
    ///   - recipe: the recipe object to be added
    ///   - folder: the folder to add the recipe to
    func addRecipeToFolder(recipe : Recipe, folderName : String){
        guard let folder = getFolder(name: folderName) else {
            print("Foldername is not valid in addRecipeToFolder")
            return
        }
        let folderIndex = folders.firstIndex(of: folder)
        guard let index = folderIndex else {
            print("Folder is not found in SavedRecipes?")
            return
        }
        folders[index].recipeMeta.append(RecipeMeta(firstAdded: Timestamp(), lastInteracted: Timestamp(), recipe: recipe))
        folders[index].recipes = enforceInvariants(folder: folders[index])
        Task(priority: .medium){
            await dbManager.updateFolders(folders: folders)
            await dbManager.addRecipe(recipe: recipe)
        }
    }
    
    /// Removes a recipe from the given folder.
    /// - Parameters:
    ///   - recipe: the recipe object to be removed
    ///   - folder: the folder to remove the recipe from
    func removeRecipeFromFolder(recipe : Recipe, folderName: String){
        guard let folder = getFolder(name: folderName) else {
            print("Foldename is not valid in removeRecipeFromFolder")
            return
        }
        let folderIndex = folders.firstIndex(of: folder)
        guard let index = folderIndex else {
            print("Folder is not found in SavedRecipes?")
            return
        }
        folders[index].recipeMeta.removeAll(where: {$0.recipe == recipe})
        folders[index].recipes = enforceInvariants(folder: folders[index])
        Task(priority: .medium){
            await dbManager.updateFolders(folders: folders)
        }
    }
    
    func isValidFolderName(name : String) -> String?{
        let newName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if newName.count == 0 {
            return "Folder name cannot be empty"
        }else if folders.contains(where: {$0.name == name}){
            return "Folder name is already taken"
        }else{
            return nil
        }
    }
    
    
    /// Creates a new folder with the given name
    /// - name: name of the new folder. MUST be unique.
    /// - Returns: true if success, false otherwise (if name is already taken)
    func createFolder(name : String) -> Bool {
        if isValidFolderName(name: name) != nil{
            return false
        }
        folders.insert(Folder(name: name), at: 0)
        return true;
    }
    
    
    /// Deletes the given folder
    /// - Parameter folderName: name of the folder
    func deleteFolder(folderName : String){
        guard folderName != "Liked Recipes" else {
            return
        }
        guard let folder = getFolder(name: folderName) else {
            print("Foldename is not valid")
            return
        }
        folders.removeAll(where: {$0 == folder})
        Task(priority: .medium){
            await dbManager.updateFolders(folders: folders)
        }
    }
}

enum Ordering {
    case alphabetical
    case alphabeticalReverse
    case recent
    case recentReverse
    
    static func fromString(ordering: String) -> Ordering{
        switch ordering {
        case "alphabetical":
            return .alphabetical
        case "alphabeticalReverse":
            return .alphabeticalReverse
        case "recent":
            return .recent
        default:
            return .recentReverse
        }
    }
    
    func toString() -> String{
        switch self {
        case .alphabetical:
            return "alphabetical"
        case .alphabeticalReverse:
            return "alphabeticalReverse"
        case .recent:
            return "recent"
        default:
            return "recentReverse"
        }
    }
}
