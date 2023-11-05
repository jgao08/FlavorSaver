//
//  RecipeSearchTests.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 11/2/23.
//

import XCTest
@testable import FlavorSaver

final class SearchTests: XCTestCase {
    
    var bananaAlmond : Search = Search()
    var vodka : Search = Search()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        APIManager.maxNumberRecipes = 5
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        bananaAlmond.addIngredient("banana")
        bananaAlmond.addIngredient("almond")
        let expectation = self.expectation(description: "Async Test")
        
        bananaAlmond.getRecipes(completion: {recipe_infos in
            
            let recipes : Recipes = self.bananaAlmond.searchResults!
            
            XCTAssert(recipes.numberOfRecipes == 5)
            XCTAssert(recipes.totalRecipes == 21)
            XCTAssert(recipes.offset == 0)
            
            
            for i in 0...4 {
                XCTAssert(recipes.recipes[i].id == recipe_infos[i].id, "Failed because \(recipes.recipes[i].id) != \(recipe_infos[i].id)")
                XCTAssert(recipes.recipes[i].title == recipe_infos[i].name, "Failed because \(recipes.recipes[i].title) != \(recipe_infos[i].name)")
                XCTAssert(recipes.recipes[i].imageType == recipe_infos[i].imageType, "Failed because \(recipes.recipes[i].imageType) != \(recipe_infos[i].imageType)")
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10)
        
        // should already exist and stored, so not necessary to reask. Should be instant.
        bananaAlmond.getRecipes(completion: {recipe_infos in
            
            let recipes : Recipes = self.bananaAlmond.searchResults!
            
            XCTAssert(recipes.numberOfRecipes == 5)
            XCTAssert(recipes.totalRecipes == 21)
            XCTAssert(recipes.offset == 0)
            
            
            for i in 0...4 {
                XCTAssert(recipes.recipes[i].id == recipe_infos[i].id, "Failed because \(recipes.recipes[i].id) != \(recipe_infos[i].id)")
                XCTAssert(recipes.recipes[i].title == recipe_infos[i].name, "Failed because \(recipes.recipes[i].title) != \(recipe_infos[i].name)")
                XCTAssert(recipes.recipes[i].imageType == recipe_infos[i].imageType, "Failed because \(recipes.recipes[i].imageType) != \(recipe_infos[i].imageType)")
            }
        })
    }
    
    func test2() throws {
        vodka.addIngredient("vodka")
        let expectation = self.expectation(description: "Async Test")
        
        vodka.getRecipes(completion: {recipe_infos in
            let recipes : Recipes = self.vodka.searchResults!
            
            XCTAssert(recipes.numberOfRecipes == 5)
            XCTAssert(recipes.totalRecipes == 1)
            XCTAssert(recipes.offset == 0)
            
            
            for i in 0...0 {
                XCTAssert(recipes.recipes[i].id == recipe_infos[i].id, "Failed because \(recipes.recipes[i].id) != \(recipe_infos[i].id)")
                XCTAssert(recipes.recipes[i].title == recipe_infos[i].name, "Failed because \(recipes.recipes[i].title) != \(recipe_infos[i].name)")
                XCTAssert(recipes.recipes[i].imageType == recipe_infos[i].imageType, "Failed because \(recipes.recipes[i].imageType) != \(recipe_infos[i].imageType)")
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10)
    }
}
