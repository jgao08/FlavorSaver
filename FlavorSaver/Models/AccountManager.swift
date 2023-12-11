//
//  Account.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/11/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class AccountManager {
    static private var db = Firestore.firestore()
    static private var auth = Auth.auth()
    
    static func signUp(username : String, profileID : Int, email : String, password : String) async throws -> User{
        let authInfo = try await auth.createUser(withEmail: email, password: password)
        let userID = authInfo.user.uid
        
        try await db.collection("users").document(userID).setData(["folders" : ["Liked Recipes" : ["name" : "Liked Recipes", "ordering" : "recent", "recipes" : [:]]], "name" : username, "profileID" : profileID])
        
        return User(userID: userID, username: username, profileID: profileID)
    }
    
    static func login(email : String, password : String) async throws -> User{
        let authInfo = try await auth.signIn(withEmail: email, password: password)
        
        return User(userID: authInfo.user.uid)
    }
    
    static func signOut(user : User) throws{
        try auth.signOut()
    }
    
    static func updateProfileID(userID : String, profileID : Int) {
        Task{
            do{
                try await db.collection("users").document(userID).updateData(["profileID" : profileID])
            }catch{
                print("Error with updating profileID in updateProfileID: \(error)")
            }
        }
    }
    
    static func getProfileID(userID : String) async -> Int {
        do{
            let profileID = try await db.collection("users").document(userID).getDocument().data()!["profileID"] as! Int
            return profileID
        }catch{
            print("Error with getting profileID in getProfileID: \(error)")
        }
        return 0
    }
    
    static func getUsername(userID : String) async -> String {
        do{
            let username = try await db.collection("users").document(userID).getDocument().data()!["name"] as! String
            return username
        }catch{
            print("Error with getting username in getUsername: \(error)")
        }
        return "User"
    }
}
