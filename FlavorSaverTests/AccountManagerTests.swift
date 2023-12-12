//
//  AccountManagerTests.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 12/12/23.
//

import XCTest
@testable import FlavorSaver
import FirebaseAuth

final class AccountManagerTests: XCTestCase {
    
    
//    func testSignUp() async throws {
//        // Ensure that the user does not already exist with the given email
//        try Auth.auth().signOut()
//        
//        let username = "testUser"
//        let profileID = 1
//        let email = "test@example.com"
//        let password = "testPassword"
//        
//        do {
//            let user = try await AccountManager.signUp(username: username, profileID: profileID, email: email, password: password)
//            XCTAssertEqual(user.getUsername(), username)
//            XCTAssertEqual(user.getProfileID(), profileID)
//            XCTAssertNotNil(user.getUserID())
//        } catch {
//            XCTFail("Error during signUp: \(error.localizedDescription)")
//        }
//    }
    
    func testLogin() async throws {
        // Ensure that the user is signed out before attempting login
        try Auth.auth().signOut()
        
        let email = "test@example.com"
        let password = "testPassword"
        
        do {
            let user = try await AccountManager.login(email: email, password: password)
            XCTAssertNotNil(user.getUserID())
        } catch {
            XCTFail("Error during login: \(error.localizedDescription)")
        }
    }
    
    
    func testSignOut() async throws {
        try Auth.auth().signOut()
        
        let email = "test@example.com"
        let password = "testPassword"
        
        do {
            let user = try await AccountManager.login(email: email, password: password)
            try AccountManager.signOut(user: user)
            
            XCTAssertNil(Auth.auth().currentUser)
        } catch {
            XCTFail("Error during signOut: \(error.localizedDescription)")
        }
    }
    
    
}
