//
//  RecipeSearchTests.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 11/2/23.
//

import XCTest
@testable import FlavorSaver

final class SearchTests: XCTestCase {
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        APIManager.maxNumberRecipes = 5
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() async throws {
        let bananaAlmond : Search = Search()
        bananaAlmond.addIngredient("banana")
        bananaAlmond.addIngredient("almond")
        
        var recipes = await bananaAlmond.getRecipes()
        
        var recipe_meta = bananaAlmond.getMetaData()
        
        XCTAssert(recipe_meta.numberOfRecipes == 5)
        XCTAssert(recipe_meta.totalRecipes == 21)
        XCTAssert(recipe_meta.offset == 0)
        
        for i in 0...4 {
            XCTAssert(recipe_meta.recipes[i].id == recipes[i].id, "Failed because \(recipe_meta.recipes[i].id) != \(recipes[i].id)")
            XCTAssert(recipe_meta.recipes[i].title == recipes[i].name, "Failed because \(recipe_meta.recipes[i].title) != \(recipes[i].name)")
            XCTAssert(recipe_meta.recipes[i].imageType == recipes[i].imageType, "Failed because \(recipe_meta.recipes[i].imageType) != \(recipes[i].imageType)")
        }
        
        // should already exist and stored, so not necessary to reask. Should be instant.
        
        recipes = await bananaAlmond.getRecipes()
        
        recipe_meta = bananaAlmond.getMetaData()
        
        XCTAssert(recipe_meta.numberOfRecipes == 5)
        XCTAssert(recipe_meta.totalRecipes == 21)
        XCTAssert(recipe_meta.offset == 0)
        
        for i in 0...4 {
            XCTAssert(recipe_meta.recipes[i].id == recipes[i].id, "Failed because \(recipe_meta.recipes[i].id) != \(recipes[i].id)")
            XCTAssert(recipe_meta.recipes[i].title == recipes[i].name, "Failed because \(recipe_meta.recipes[i].title) != \(recipes[i].name)")
            XCTAssert(recipe_meta.recipes[i].imageType == recipes[i].imageType, "Failed because \(recipe_meta.recipes[i].imageType) != \(recipes[i].imageType)")
        }
    }
    
    func test2() async throws {
        let vodka : Search = Search()
        vodka.addIngredient("vodka")
        
        let recipes = await vodka.getRecipes()
        let recipe_meta = vodka.getMetaData()
        
        
        XCTAssert(recipe_meta.numberOfRecipes == 5)
        XCTAssert(recipe_meta.totalRecipes == 1)
        XCTAssert(recipe_meta.offset == 0)
        
        
        for i in 0...0 {
            XCTAssert(recipe_meta.recipes[i].id == recipes[i].id, "Failed because \(recipe_meta.recipes[i].id) != \(recipes[i].id)")
            XCTAssert(recipe_meta.recipes[i].title == recipes[i].name, "Failed because \(recipe_meta.recipes[i].title) != \(recipes[i].name)")
            XCTAssert(recipe_meta.recipes[i].imageType == recipes[i].imageType, "Failed because \(recipe_meta.recipes[i].imageType) != \(recipes[i].imageType)")
        }
    }
    
    func testIngredients(){
        let sampleSearch : Search = Search()
        
        XCTAssert(sampleSearch.getCurrentSelectedIngredients().count == 0)
        
        sampleSearch.addIngredient("potato")
        XCTAssert(sampleSearch.getCurrentSelectedIngredients().contains("potato"))
        
        sampleSearch.addIngredient("banana")
        XCTAssert(sampleSearch.getCurrentSelectedIngredients().contains("potato"))
        XCTAssert(sampleSearch.getCurrentSelectedIngredients().contains("banana"))
        
        sampleSearch.removeIngredient("potato")
        XCTAssert(!sampleSearch.getCurrentSelectedIngredients().contains("potato"))
        XCTAssert(sampleSearch.getCurrentSelectedIngredients().contains("banana"))
        
        sampleSearch.removeIngredient("banana")
        XCTAssert(!sampleSearch.getCurrentSelectedIngredients().contains("potato"))
        XCTAssert(!sampleSearch.getCurrentSelectedIngredients().contains("banana"))
        
        XCTAssert(sampleSearch.getCurrentSelectedIngredients().count == 0)
    }
    
    func testIngredientSearch(){
        let sampleSearch : Search = Search()
        let ingredients : Ingredients = Ingredients()
        
        let aIngredients = sampleSearch.getIngredientOptions("a")
        let cIngredients = sampleSearch.getIngredientOptions("c")
        
        let aMoreIngredients = sampleSearch.getIngredientOptions("app")
        let cMoreIngredients = sampleSearch.getIngredientOptions("cat")
        
        XCTAssert(aIngredients == ingredients.ingredients["a"])
        XCTAssert(cIngredients == ingredients.ingredients["c"])
        
        XCTAssert(aMoreIngredients == ["apple", "apple butter", "apple cider", "apple cider vinegar", "apple jelly", "apple juice", "apple pie filling", "apple pie spice"])
        XCTAssert(cMoreIngredients == ["catalina dressing", "catfish fillets"])
        
        let nothing = sampleSearch.getIngredientOptions("")
        XCTAssert(nothing.count == 0)
    }
}
