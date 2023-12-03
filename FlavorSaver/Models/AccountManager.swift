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
    
    static func signUp(username : String, email : String, password : String) async throws -> User{
        let authInfo = try await auth.createUser(withEmail: email, password: password)
        let userID = authInfo.user.uid
        let profileChange = authInfo.user.createProfileChangeRequest()
        profileChange.displayName = username
        try await profileChange.commitChanges()
        
        try await db.collection("users").document(userID).setData(["name" : username, "savedRecipeIDs" : []])
        
        return User(userID: userID, username: username)
    }
    
    static func login(email : String, password : String) async throws -> User{
        let authInfo = try await auth.signIn(withEmail: email, password: password)
        let userID = authInfo.user.uid
        let profileName = authInfo.user.displayName!
        
        return User(userID: userID, username: profileName)
    }
    
    static func signOut(user : User) async throws{
        try auth.signOut()
    }
}
