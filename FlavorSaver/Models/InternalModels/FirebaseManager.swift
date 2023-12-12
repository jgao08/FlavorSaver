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
    
    func retrieveSavedFolders() async -> [Folder] {
        var result : [Folder] = []
        do{
            let savedFolders : [String : FirebaseFolder] = try await getFolders()
            
            guard (savedFolders.count > 0) else {
                return result
            }
            
            for (name,folder) in savedFolders {
                guard folder.recipeMeta.count > 0 else {
                    result.append(Folder(recipeMeta: [], ordering: Ordering.fromString(ordering: folder.ordering), name: name))
                    continue
                }
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
        
    func addRecipe(recipe : Recipe) async {
        do {
            let document = try await recipeCollection.document(String(recipe.id)).getDocument()
            if !document.exists{
                try recipeCollection.document(String(recipe.id)).setData(from: recipe)
            }
        } catch{
            print("Error adding recipe to database \(error.localizedDescription)")
        }
    }
}
