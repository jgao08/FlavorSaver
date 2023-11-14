//
//  UserTest.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 11/5/23.
//

import XCTest
import SwiftUI
@testable import FlavorSaver

@MainActor
final class UserTest: XCTestCase {
    var user : User = User(userID : "-1", username : "fake user")
    
    override func setUpWithError() throws {
        let _ = user.getSavedRecipes().map {user.removeSavedRecipe(recipe: $0)}
        print("Successfully removed all SETUP recipes? \(user.getSavedRecipes().count)")
    }
    
    override func tearDownWithError() throws {
        let _ = user.getSavedRecipes().map {user.removeSavedRecipe(recipe: $0)}
        print("Successfully removed all TEARDOWN recipes? \(user.getSavedRecipes().count)")
    }
    
    // Sometimes passes sometimes fails
    func testExample() async throws {
        let vodka : Search = Search()
        vodka.addIngredient("vodka")
        
        await vodka.executeSearch()
        let recipes = vodka.getRecipes()
        
        XCTAssert(recipes.count == 1)
        let firstRecipe = recipes.first!
        
        // Add this vodka recipe
        
        user.addSavedRecipe(recipe: firstRecipe)
        
        XCTAssert(user.isRecipeSaved(recipeID: firstRecipe.id))
        
        let savedRecipes = user.getSavedRecipes()
        
        XCTAssert(recipes.count == 1)
        let recipeAgain = savedRecipes.first!
        
        XCTAssert(recipeAgain == firstRecipe)
    }
    
    func test2() async throws {
        let bananaAlmond : Search = Search()
        bananaAlmond.addIngredient("banana")
        bananaAlmond.addIngredient("almond")
        
        await bananaAlmond.executeSearch()
        let recipes = bananaAlmond.getRecipes()
        
        XCTAssert(recipes.count == 5)
        
        
        // Add both recipes
        user.addSavedRecipe(recipe: recipes[0])
        user.addSavedRecipe(recipe: recipes[2])
        
        print("real size: \(user.getSavedRecipes().count)")
        
        XCTAssert(user.getSavedRecipes().contains(recipes[0]))
        XCTAssert(user.getSavedRecipes().contains(recipes[2]))
        
        XCTAssert(user.isRecipeSaved(recipeID: recipes[0].id))
        XCTAssert(user.isRecipeSaved(recipeID: recipes[2].id))
        XCTAssert(!user.isRecipeSaved(recipeID: recipes[1].id))
        XCTAssert(!user.isRecipeSaved(recipeID: recipes[3].id))
        
        // Remove first one
        user.removeSavedRecipe(recipe: recipes[0])
        
        XCTAssert(!user.getSavedRecipes().contains(recipes[0]))
        XCTAssert(user.getSavedRecipes().contains(recipes[2]))
        
        XCTAssert(!user.isRecipeSaved(recipeID: recipes[0].id))
        XCTAssert(user.isRecipeSaved(recipeID: recipes[2].id))
        XCTAssert(!user.isRecipeSaved(recipeID: recipes[1].id))
        XCTAssert(!user.isRecipeSaved(recipeID: recipes[3].id))
        
        // Remove second one
        user.removeSavedRecipe(recipe: recipes[2])
        
        XCTAssert(!user.getSavedRecipes().contains(recipes[0]))
        XCTAssert(!user.getSavedRecipes().contains(recipes[2]))
        
        XCTAssert(!user.isRecipeSaved(recipeID: recipes[0].id))
        XCTAssert(!user.isRecipeSaved(recipeID: recipes[2].id))
        XCTAssert(!user.isRecipeSaved(recipeID: recipes[1].id))
        XCTAssert(!user.isRecipeSaved(recipeID: recipes[3].id))
        
        XCTAssert(user.getUserID() == "-1")
    }
}
