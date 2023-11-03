//
//  RecipeSearchTests.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 11/2/23.
//

import XCTest
@testable import FlavorSaver

final class SearchTests: XCTestCase {
    
    var recipe1 : Search = Search()
    var recipe2 : Search = Search()
    var recipe3 : Search = Search()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        recipe1.addIngredient("banana")
        recipe1.addIngredient("almond")
        
        
        recipe1.getRecipes(completion: {recipe_infos in
            
            let recipes : Recipes = self.recipe1.searchResults!
            
            print(recipe_infos)
            print("hiiiiii")
            
            XCTAssert(false)
            XCTAssert(recipes.numberOfRecipes == 30)
            XCTAssert(recipes.totalRecipes == 21)
            XCTAssert(recipes.offset == 0)
            
            XCTAssert(recipes.recipes.first != nil)
            let firstRecipe : Recipe = recipes.recipes.first!
            XCTAssert(firstRecipe.title == "Matcha Smoothie")
            XCTAssert(firstRecipe.image == "https://spoonacular.com/recipeImages/1095931-312x231.jpg")
            
            XCTAssert(recipes.recipes.count > 2)
            let thirdRecipe : Recipe = recipes.recipes[2]
            XCTAssert(thirdRecipe.title == "Banana Almond Cake")
            XCTAssert(thirdRecipe.image == "https://spoonacular.com/recipeImages/633975-312x231.jpg")
            
        })
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
