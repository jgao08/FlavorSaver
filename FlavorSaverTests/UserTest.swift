//
//  UserTest.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 11/5/23.
//

import XCTest
@testable import FlavorSaver

final class UserTest: XCTestCase {
    var user : User = User(userID : 0)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        user = User(userID : 9202)
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    func testExample() async throws {
        let vodka : Search = Search()
        //user = User(userID: 0)
        vodka.addIngredient("vodka")
        
        let recipes = await vodka.getRecipes()
        
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
        
        let recipes = await bananaAlmond.getRecipes()
        
        XCTAssert(recipes.count == 5)
        
        // Add both recipes
        user.addSavedRecipe(recipe: recipes[0])
        user.addSavedRecipe(recipe: recipes[2])
        
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
        
    }
    
}
