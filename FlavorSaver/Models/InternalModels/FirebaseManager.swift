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
                
    
                result.append(Folder(recipeMeta: firebaseRecipeMeta.values.map({firebaseRecipe in firebaseRecipe.toRecipeMeta(recipe: recipes.first(where: {String($0.id) == firebaseRecipe.recipeID})!)}),
                                     ordering: Ordering.fromString(ordering: folder.ordering),
                                     name: name))
            }
            return result
            
        }catch{
            print("Error with retrieving saved folders in retrieveSavedFolders: \(error)")
        }
        return result
    }
    
    private func getFolders() async throws -> [String : FirebaseFolder]{
        var document = try await userDocument.getDocument()
        if !document.exists {
            try await userDocument.setData(["folders" : ["Liked Recipes": [:]]])
            document = try await userDocument.getDocument()
        }
        if let foldersData = document["folders"] as? [String: Any] {
            let convertedData = try Firestore.Decoder().decode([String: FirebaseFolder].self, from: foldersData)
            return convertedData
        }
        return [:]
    }
    
    func updateFolders(folders : [Folder]) async {
        do{
            let mappedNames = folders.map {folder in (folder.name, FirebaseFolder.toFirebaseFolder(folder: folder))}
            let newFolders = Dictionary(uniqueKeysWithValues: mappedNames)
            try await updateFolders(folders: newFolders)
        }catch{
            print("Error in updating user document: \(error.localizedDescription)")
        }
    }
    
    private func updateFolders(folders : [String : FirebaseFolder]) async throws{
        let encodedValue = try Firestore.Encoder().encode(folders)
        var data = try await userDocument.getDocument().data()
        data?["folders"] = encodedValue
        try await userDocument.setData(data!)
    }
    
    private func recipeInSavedList(recipeID : Int) async -> Bool {
        do {
            let document = try await recipeCollection.document(String(recipeID)).getDocument()
            return document.exists
        } catch{
            print("Error in retrieving document in recipeInSavedList \(error.localizedDescription)")
        }
        return false
    }
    
    func addRecipe(recipe : Recipe) async {
        if (!(await recipeInSavedList(recipeID: recipe.id))){
            do{
                try recipeCollection.document(String(recipe.id)).setData(from: recipe)
            }catch{
                print("Error in adding recipe to database: \(error.localizedDescription)")
            }
        }
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
