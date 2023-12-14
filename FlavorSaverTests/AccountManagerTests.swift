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
        
    func testLogin() async throws {
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
