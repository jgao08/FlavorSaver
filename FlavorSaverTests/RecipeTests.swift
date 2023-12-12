//
//  RecipeTests.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 12/12/23.
//

import XCTest
@testable import FlavorSaver

final class RecipeTests: XCTestCase {
    
    let testRecipe1 = Recipe(
        id: 1,
        name: "Test Recipe",
        image: "test_image_url",
        imageType: "jpg",
        servings: 4,
        readyInMinutes: 30,
        author: "Test Author",
        authorURL: "http://test-author.com",
        spoonURL: "http://spoon-test.com",
        summary: "This is a test recipe.",
        cuisines: ["Italian"],
        dishTypes: ["Main Course"],
        ingredientInfo: [Ingredient(id: 1, name: "Ingredient1", amount: 1.0, original: "1 cup Ingredient1", originalName: "Ingredient1", unit: "cup")],
        ingredientSteps: [RecipeInstructions(name: "Step 1", steps: [RecipeStep(number: 1, step: "Step 1", ingredients: [StepIngredient(id: 1, name: "Ingredient1")])])]
    )
    
    let testRecipe2 = Recipe(
        id: 2,
        name: "Test Recipe 2",
        image: "test_image_url_2",
        imageType: "png",
        servings: 2,
        readyInMinutes: 45,
        author: "Test Author 2",
        authorURL: "http://test-author-2.com",
        spoonURL: "http://spoon-test-2.com",
        summary: "This is another test recipe.",
        cuisines: ["Mexican"],
        dishTypes: ["Dessert"],
        ingredientInfo: [Ingredient(id: 2, name: "Ingredient2", amount: 2.0, original: "2 cups Ingredient2", originalName: "Ingredient2", unit: "cups")],
        ingredientSteps: [RecipeInstructions(name: "Step 1", steps: [RecipeStep(number: 1, step: "Step 1", ingredients: [StepIngredient(id: 2, name: "Ingredient2")])])]
    )
    
    func testGetIngredients() {
        XCTAssertEqual(testRecipe1.getIngredients(), ["Ingredient1"])
        XCTAssertEqual(testRecipe2.getIngredients(), ["Ingredient2"])
    }
    
    func testGetIngredientsWithAmounts() {
        XCTAssertEqual(testRecipe1.getIngredientsWithAmounts(), ["1 cup Ingredient1"])
        XCTAssertEqual(testRecipe2.getIngredientsWithAmounts(), ["2 cups Ingredient2"])
    }
    
    func testGetRecipeSteps() {
        let expectedSteps = [("Step 1", ["Ingredient1"])]
        let resultSteps = testRecipe1.getRecipeSteps()
        
        XCTAssertEqual(resultSteps.count, expectedSteps.count)
        
        for (result, expected) in zip(resultSteps, expectedSteps) {
            XCTAssertEqual(result.0, expected.0)
            XCTAssertEqual(result.1, expected.1)
        }
    }
    
    func testGetRecipeStepsWithAmounts() {
        let expectedStepsWithAmounts = [(1, "Step 1", ["1 cup Ingredient1"])]
        let resultStepsWithAmounts = testRecipe1.getRecipeStepsWithAmounts()
        print(resultStepsWithAmounts)
        
        XCTAssertEqual(resultStepsWithAmounts.count, expectedStepsWithAmounts.count)
        
        for (result, expected) in zip(resultStepsWithAmounts, expectedStepsWithAmounts) {
            XCTAssertEqual(result.0, expected.0)
            XCTAssertEqual(result.1, expected.1)
            XCTAssertEqual(result.2, expected.2)
        }
    }
    
    func testEquality() {
        XCTAssertEqual(testRecipe1, testRecipe1)
        XCTAssertNotEqual(testRecipe1, testRecipe2)
    }
    
}
