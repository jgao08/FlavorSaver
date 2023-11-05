//
//  UserTest.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 11/5/23.
//

import XCTest
@testable import FlavorSaver

final class UserTest: XCTestCase {
    var vodka : Search = Search()
    var user : User = User(userID : 0)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        vodka.addIngredient("vodka")
        let expectation = self.expectation(description: "Async Test")
        
        vodka.getRecipes(completion: {recipe_infos in
            
            XCTAssert(recipe_infos.count == 1)
            let firstRecipe = recipe_infos.first!
            
            self.user.addSavedRecipe(recipe: firstRecipe)
            // TEMPORARY
            sleep(5)
            
            XCTAssert(self.user.isRecipeSaved(recipeID: firstRecipe.id))
            
            self.user.getSavedRecipes(completion: {recipe_infos in
                
                XCTAssert(recipe_infos.count == 1)
                let recipeAgain = recipe_infos.first!
                
                XCTAssert(recipeAgain == firstRecipe)
                expectation.fulfill()
            })
        })
        waitForExpectations(timeout: 10)
    }

}
