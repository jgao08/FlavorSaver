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
    private var lock = NSLock()
    
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
            print("Error with retrieving saved recipes : \(error)")
        }
        return result
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
        
    // Need some sort of lock for race-condition adds to database
    func addRecipeToUser(recipe : Recipe) async {
        lock.lock()
        defer{
            lock.unlock()
        }
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
        lock.lock()
        defer{
            lock.unlock()
        }
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
