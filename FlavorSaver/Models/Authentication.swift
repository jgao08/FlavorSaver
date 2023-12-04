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
        checkUserAuthentication()
    }

    func configureFirebaseAuthStateListener() {
        auth.addStateDidChangeListener { (_, user) in
            if let user = user {
                self.currentUser = User(userID: user.uid, username: user.displayName!)
            } else {
                self.currentUser = nil
            }
        }
    }

    private func checkUserAuthentication() {
        if let user = auth.currentUser {
            self.currentUser = User(userID: user.uid, username: user.displayName!)
        } else {
            self.currentUser = nil
        }
    }
}
