//
//  FirebaseManager.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/5/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

// TODO: Support multiple users. Requires authentication and creating new data when account is created
class FirebaseManager {
    private var db = Firestore.firestore()
    private var recipeCollection : CollectionReference
    private var userDocument : DocumentReference
    
    init(userID : String){
        recipeCollection = db.collection("recipes")
        userDocument = db.collection("users").document(userID)
    }
    
    func retrieveSavedRecipes() async -> [Recipe] {
        var result : [Recipe] = []
        do{
            let document = try await userDocument.getDocument()
            guard document.exists else {
                try await userDocument.setData(["savedRecipeIDs" : []])
                return result
            }
            let data = document.data()
            let savedRecipes = data?["savedRecipeIDs"] as? [String] ?? []
            
            guard (savedRecipes.count > 0) else {
                return result
            }
            let querySnapshot = try await recipeCollection.whereField(FieldPath.documentID(), in: savedRecipes).getDocuments()
            
            for document in querySnapshot.documents {
                let recipe = try document.data(as: Recipe.self)
                result.append(recipe)
            }
            return result
            
        }catch{
            print("Error with retrieving saved recipes in retrieveSavedRecipes: \(error)")
        }
        return result
    }
    
    func retrieveSavedFolders() async -> [Folder] {
        var result : [Folder] = []
        do{
            let savedFolders : [String : FirebaseFolder] = try await getFolders()
            
            guard (savedFolders.count > 0) else {
                return result
            }
            
            for (name,folder) in savedFolders {
                let querySnapshot = try await recipeCollection.whereField(FieldPath.documentID(), in: folder.recipeMeta.values.map({recipe in recipe.recipeID})).getDocuments()
                
                var recipes : [Recipe] = []
                for document in querySnapshot.documents {
                    let recipe = try document.data(as: Recipe.self)
                    recipes.append(recipe)
                }
                let firebaseRecipeMeta = folder.recipeMeta
                
    
                result.append(Folder(recipeMeta: firebaseRecipeMeta.values.map({firebaseRecipe in toRecipeMeta(recipe: recipes.first(where: {String($0.id) == firebaseRecipe.recipeID})!, firstAdded: firebaseRecipe.firstAdded, lastInteracted: firebaseRecipe.lastInteracted)}),
                                     ordering: Ordering.fromString(ordering: folder.ordering),
                                     name: name))
            }
            return result
            
        }catch{
            print("Error with retrieving saved folders in retrieveSavedFolders: \(error)")
        }
        return result
    }
    
    func toRecipeMeta(recipe : Recipe, firstAdded: Timestamp, lastInteracted: Timestamp) -> RecipeMeta{
        return RecipeMeta(firstAdded: firstAdded, lastInteracted: lastInteracted, recipe: recipe)
    }
    
    private func getFolders() async throws -> [String : FirebaseFolder]{
        var document = try await userDocument.getDocument()
        if !document.exists {
            try await userDocument.setData(["folders" : ["all": [:]]])
            document = try await userDocument.getDocument()
        }
        if let foldersData = document["folders"] as? [String: Any] {
            let convertedData = try Firestore.Decoder().decode([String: FirebaseFolder].self, from: foldersData)
            print(" is the converted data")
            return convertedData
        }
        return [:]
    }
    
    func updateFolders(folders : [Folder]) async {
        do{
            let newFolders = Dictionary(uniqueKeysWithValues: folders.map{folder in (folder.name, FirebaseFolder(ordering: folder.ordering.toString(), name: folder.name, recipeMeta: Dictionary(uniqueKeysWithValues: folder.recipeMeta.map({recipe in (String(recipe.recipe.id), recipe.toFirebaseRecipeMeta())}))))})
            try await updateFolders(folders: newFolders)
        }catch{
            print("Error in updating user document: \(error.localizedDescription)")
        }
    }
    
    private func updateFolders(folders : [String : FirebaseFolder]) async throws{
        let encodedValue = try Firestore.Encoder().encode(folders)
        try await userDocument.setData(encodedValue)
    }
    
//    func addRecipeToFolder(recipe: Recipe, folderName : String) async{
//        do{
//            var savedFolders : [String : FirebaseFolder] = try await getFolders()
//            
//            if let theFolder = savedFolders[folderName] {
//                let updatedFolder = updateLocalRecipeFromFolder(recipeID: String(recipe.id), folder: theFolder, add: true)
//                savedFolders.updateValue(updatedFolder, forKey: folderName)
//                try await updateFolders(folders: savedFolders)
//            }
//        }catch{
//            print("Error in updating user document: \(error.localizedDescription)")
//        }
//    }
//    
//    func removeRecipeFromFolder(recipeID: String, folderName : String) async {
//        if (folderName == "All"){
//            await removeRecipeFromAll(recipeID: recipeID)
//            return;
//        }
//        do{
//            var savedFolders : [String : FirebaseFolder] = try await getFolders()
//            
//            if let theFolder = savedFolders[folderName] {
//                let updatedFolder = updateLocalRecipeFromFolder(recipeID: recipeID, folder: theFolder, add: false)
//                savedFolders.updateValue(updatedFolder, forKey: folderName)
//                try await updateFolders(folders: savedFolders)
//            }
//        }catch{
//            print("Error in updating user document: \(error.localizedDescription)")
//        }
//    }
//    
//    private func removeRecipeFromAll(recipeID: String) async{
//        do{
//            var savedFolders : [String : FirebaseFolder] = try await getFolders()
//            for (folderName, theFolder) in savedFolders {
//                let updatedFolder = updateLocalRecipeFromFolder(recipeID: recipeID, folder: theFolder, add: false)
//                savedFolders.updateValue(updatedFolder, forKey: folderName)
//            }
//            try await updateFolders(folders: savedFolders)
//        }catch{
//            print("Error in updating user document: \(error.localizedDescription)")
//        }
//    }
    
//    private func updateLocalRecipeFromFolder(recipeID: String, folder: FirebaseFolder, add: Bool) -> FirebaseFolder{
//        var recipeIDs = folder.recipeMeta.recipeIDs
//        if (add){
//            recipeIDs.append(recipeID)
//        }else{
//            recipeIDs.removeAll(where: {$0 == recipeID})
//        }
//        return FirebaseFolder(ordering: folder.ordering, recipeMeta: FirebaseRecipeMeta(firstAdded: folder.recipeMeta.firstAdded, lastInteracted: folder.recipeMeta.lastInteracted, recipeIDs: recipeIDs))
//    }
//    
//    func updateFolderOrdering(folderName: String, ordering: String) async {
//        do{
//            var savedFolders : [String : FirebaseFolder] = try await getFolders()
//            if let theFolder = savedFolders[folderName] {
//                savedFolders.updateValue(FirebaseFolder(ordering: ordering, recipeMeta: theFolder.recipeMeta), forKey: folderName)
//            }
//            try await updateFolders(folders: savedFolders)
//        }catch{
//            print("Error in updating user document: \(error.localizedDescription)")
//        }
//    }
    
    
    private func recipeInSavedList(recipeID : Int) async -> Bool {
        do {
            let document = try await recipeCollection.document(String(recipeID)).getDocument()
            return document.exists
        } catch{
            print("Error in retrieving document in recipeInSavedList \(error.localizedDescription)")
        }
        return false
    }
    
    // Need some sort of lock for race-condition adds to database
    func addRecipeToUser(recipe : Recipe) async {
        do{
            let document = try await userDocument.getDocument()
            guard document.exists else{
                return
            }
            var data = document.data() ?? [:]
            var savedRecipes = data["savedRecipeIDs"] as? [String] ?? []
            
            // Check if the recipeID is in the master list and remove it if so
            if !savedRecipes.contains(String(recipe.id)) {
                savedRecipes.append(String(recipe.id))
                
                data["savedRecipeIDs"] = savedRecipes
                try await userDocument.setData(data, merge: true)
                
                // Check if recipe is currently in the master list, if not then add it
                if (!(await recipeInSavedList(recipeID: recipe.id))){
                    try recipeCollection.document(String(recipe.id)).setData(from: recipe)
                }
            }
            
        }catch{
            print("Error in adding recipe to user: \(error.localizedDescription)")
        }
    }
    
    func removeRecipeFromUser(recipeID : Int) async {
        do{
            let document = try await userDocument.getDocument()
            guard document.exists else {
                return
            }
            var data = document.data() ?? [:]
            var savedRecipes = data["savedRecipeIDs"] as? [String] ?? []
            
            // Check if the recipeID is in the master list and remove it if so
            if let index = savedRecipes.firstIndex(of: String(recipeID)) {
                savedRecipes.remove(at: index)
                data["savedRecipeIDs"] = savedRecipes
                try await userDocument.setData(data, merge: true)
            }
        }catch{
            print("Error in updating user document: \(error.localizedDescription)")
        }
    }
    
}
