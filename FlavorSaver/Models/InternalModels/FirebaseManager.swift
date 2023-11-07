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
        do{
            let document = try await userDocument.getDocument()
            if document.exists {
                let data = document.data()
                let savedRecipes = data?["savedRecipeIDs"] as? [String] ?? []
                
                if (savedRecipes == []){
                    return []
                }
                let querySnapshot = try await recipeCollection.whereField(FieldPath.documentID(), in: savedRecipes).getDocuments()
                
                var result: [Recipe] = []
                
                for document in querySnapshot.documents {
                    let recipe = try document.data(as: Recipe.self)
                    result.append(recipe)
                }
                return result
            }else{
                try await userDocument.setData(["savedRecipeIDs" : []])
                return []
            }
        }catch{
            print("Error with retrieving saved recipes : \(error)")
        }
        return []
    }
    
    private func recipeInSavedList(recipeID : Int, completion : @escaping (Bool) -> Void){
        recipeCollection.document(String(recipeID)).getDocument { (docSnap, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if docSnap!.exists {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    // Unused, can be used to test consistency between local and firebase
//    private func isRecipeSaved(recipeID : Int, completion :  @escaping (Bool) -> Void){
//        userDocument.getDocument(completion: {(document, error) in
//            if let document = document, document.exists {
//                let data = document.data()
//                let savedRecipes = data?["savedRecipeIDs"] as? [String] ?? []
//                let result = savedRecipes.contains(String(recipeID))
//                completion(result)
//            }else{
//                print("Document does not exist. Could be wrong userID.")
//            }
//        })
//    }
    
    // Need some sort of lock for race-condition adds to database
    func addRecipeToUser(recipe : Recipe){
        userDocument.getDocument(completion: {(document, error) in
            if let document = document, document.exists {
                var data = document.data() ?? [:]
                var savedRecipes = data["savedRecipeIDs"] as? [String] ?? []
                
                // Check if the current recipe is in user's list
                if !savedRecipes.contains(String(recipe.id)) {
                    savedRecipes.append(String(recipe.id))
                    
                    data["savedRecipeIDs"] = savedRecipes
                    self.userDocument.setData(data, merge: true) { error in
                        if let error = error {
                            print("Error updating user document: \(error.localizedDescription)")
                        }
                    }
                    
                    // Check if recipe is currently in the master list, if not then add it
                    self.recipeInSavedList(recipeID: recipe.id, completion: { val in
                        if (!val){
                            do {
                                try self.recipeCollection.document(String(recipe.id)).setData(from: recipe)
                            }catch{
                                print("Error encoding document: \(error.localizedDescription)")
                            }
                        }
                    })
                }
                
            }else{
                print("Document does not exist. Could be wrong userID.")
            }
        })
    }
    
    func removeRecipeFromUser(recipeID : Int){
        userDocument.getDocument(completion: {(document, error) in
            if let document = document, document.exists {
                var data = document.data() ?? [:]
                var savedRecipes = data["savedRecipeIDs"] as? [String] ?? []
                
                // Check if the recipeID is in the master list and remove it if so
                if let index = savedRecipes.firstIndex(of: String(recipeID)) {
                    savedRecipes.remove(at: index)
                    data["savedRecipeIDs"] = savedRecipes
                    self.userDocument.setData(data, merge: true) { error in
                        if let error = error {
                            print("Error updating user document: \(error.localizedDescription)")
                        }
                    }
                }
                
            }else{
                print("Document does not exist. Could be wrong userID.")
            }
        })
    }
    
}
