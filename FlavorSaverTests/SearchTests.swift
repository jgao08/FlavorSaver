//
//  SearchTests.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 11/2/23.
//

import XCTest
@testable import FlavorSaver

@MainActor
final class SearchTests: XCTestCase {
    var search: Search!
    
    override func setUpWithError() throws {
        APIManager.maxNumberRecipes = 5
        search = Search()
    }

    func testAddIngredient() {
        let ingredient = "Tomato"
        search.addIngredient(ingredient)
        XCTAssertTrue(search.getCurrentSelectedIngredients().contains(ingredient.lowercased()))
    }
    
    func testAddExistingIngredient() {
        let ingredient = "Tomato"
        search.addIngredient(ingredient)
        search.addIngredient(ingredient)
        XCTAssertEqual(search.getCurrentSelectedIngredients().filter { $0 == ingredient.lowercased() }.count, 1)
    }
    
    
    func testRemoveIngredient() {
        let ingredient = "Onion"
        search.addIngredient(ingredient)
        search.removeIngredient(ingredient)
        XCTAssertFalse(search.getCurrentSelectedIngredients().contains(ingredient.lowercased()))
    }
    
    func testRemoveNonexistentIngredient() {
        let ingredient = "Garlic"
        search.removeIngredient(ingredient)
        XCTAssertFalse(search.getCurrentSelectedIngredients().contains(ingredient.lowercased()))
    }
    
    func testRemoveMultipleIngredients() {
        let ingredient1 = "Tomato"
        let ingredient2 = "Garlic"
        search.addIngredient(ingredient1)
        search.addIngredient(ingredient2)
        search.removeIngredient(ingredient2)
        
        XCTAssertTrue(search.getCurrentSelectedIngredients().contains(ingredient1.lowercased()))
        XCTAssertFalse(search.getCurrentSelectedIngredients().contains(ingredient2.lowercased()))
        
        search.removeIngredient(ingredient2)
        
        XCTAssertTrue(search.getCurrentSelectedIngredients().contains(ingredient1.lowercased()))
        XCTAssertFalse(search.getCurrentSelectedIngredients().contains(ingredient2.lowercased()))
        
        search.removeIngredient(ingredient1)
        
        XCTAssertFalse(search.getCurrentSelectedIngredients().contains(ingredient1.lowercased()))
        XCTAssertFalse(search.getCurrentSelectedIngredients().contains(ingredient2.lowercased()))
    }
    
    func testExecuteSearch() async {
        let ingredient1 = "Tomato"
        let ingredient2 = "Garlic"
        search.addIngredient(ingredient1)
        search.addIngredient(ingredient2)
    
        await search.executeSearch()
        
        XCTAssertEqual(search.getRecipes().count, 4)
        
        XCTAssertTrue(search.getRecipesWithTags().count > 0)
    }
        
    func testGetIngredientOptions() {
        let input = "to"
        let options = search.getIngredientOptions(input)
        print(options)
        XCTAssertTrue(options.contains("tomatoes"))
        XCTAssertTrue(options.contains("tofu"))
        XCTAssertFalse(options.contains("onion"))
    }
    
    func testGetIngredientOptionsEmpty() {
        let input = ""
        let options = search.getIngredientOptions(input)
        XCTAssertEqual(options.count, 0)
    }
    
    func testGetIngredientOptionsNoMatches() {
        let input = "z"
        let options = search.getIngredientOptions(input)
        XCTAssertEqual(options.count, 1)
        XCTAssertEqual(options[0], "z")
    }
}
