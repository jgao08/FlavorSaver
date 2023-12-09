//
//  AuthenticationViewModel.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 12/3/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

class Authentication: ObservableObject {
    @Published var currentUser: User?
    private var auth = Auth.auth()

    init() {
        configureFirebaseAuthStateListener()
    }

    func configureFirebaseAuthStateListener() {
        auth.addStateDidChangeListener { (auth, user) in
            if let user = user{
                self.currentUser = User(userID: user.uid)
            } else {
                self.currentUser = nil
            }
        }
    }
}
