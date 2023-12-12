//
//  RecommendedTests.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 12/12/23.
//

import XCTest
@testable import FlavorSaver

@MainActor
final class RecommendedTests: XCTestCase {
        
    override func setUpWithError() throws {
        APIManager.maxNumberRecipes = 5
    }

    func testInitialization() async {
        let recommended = await Recommended()
        XCTAssertFalse(recommended.getRecommendedRecipes().isEmpty)
        XCTAssertTrue(recommended.getRecommendedRecipes().count <= APIManager.maxNumberRecipes)
    }
    
    func testExecuteRandomSearch() async {
        let recommended = await Recommended()
        let oldRecipes = recommended.getRecommendedRecipes()
        await recommended.executeRandomSearch()
        let newRecipes = recommended.getRecommendedRecipes()
        
        XCTAssertFalse(newRecipes.isEmpty)
        XCTAssertTrue(newRecipes.count <= APIManager.maxNumberRecipes)
        
        XCTAssertNotEqual(oldRecipes, newRecipes)
    }
    
}
