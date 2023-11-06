//
//  RecipeTests.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 11/6/23.
//

import XCTest
@testable import FlavorSaver

final class RecipeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() async throws {
        let vodkaSearch = RecipeSearch(recipeID: 640026)
        XCTAssert(vodkaSearch.getRecipeID() == 640026)
        
        let result : Recipe = await vodkaSearch.getRecipeInfo()
        
        let ingredientTruth = ["extra-virgin olive oil", "garlic cloves, minced", "shallots, minced", "piment d\'Espelette or crushed red pepper flakes, optional", "vodka", "whole, peeled tomatoes (See the Guide)", "heavy cream", "freshly grated Parmigiano-Reggiano, plus more for serving", "loosely packed fresh basil leaves", "loosely packed fresh basil leaves", "penne", "salt and freshly ground black pepper, to taste"]
        
        let ingredientAmountTruth = ["2 tablespoons extra-virgin olive oil", "2 garlic cloves, minced", "2 shallots, minced", "1/4 teaspoon piment d\'Espelette or crushed red pepper flakes, optional", "1/2 cup vodka", "28 ounce can whole, peeled tomatoes (See the Guide)", "cup heavy cream", "1/2 cup freshly grated Parmigiano-Reggiano, plus more for serving", "1/4 cup loosely packed fresh basil leaves", "1/4 cup loosely packed fresh basil leaves", "1 pound penne", "salt and freshly ground black pepper, to taste"]
        
        let stepsTruth = [("In a large heavy-bottomed French or Dutch oven, heat the oil over medium high heat.", ["cooking oil"]), ("Add the garlic and shallots and gently saute for 3-5 minutes, stirring constantly until fragrant and translucent. Lower the heat if the garlic starts to brown.", ["shallot", "garlic"]), ("Add the piment dEspelette or red pepper flakes, if using.", ["red pepper flakes"]), ("Pour in the vodka and let reduce by half, another 3-5 minutes.", ["vodka"]), ("Add in the tomatoes and a sprinkling of salt. Bring to a boil and let simmer, uncovered, stirring often to break up the tomatoes, until sauce is thick, about 15 minutes.", ["tomato", "sauce", "salt"]), ("Meanwhile, bring a large stockpot of water to a boil over high heat. Once the water boils, salt the water and cook penne until just under al dente, about 9 minutes and then drain in a colander.", ["penne", "water", "salt"]), ("While the pasta cooks, stir cream into the thickened tomato sauce. Bring to a boil and lower heat to a simmer. Season again with salt and pepper to taste.", ["salt and pepper", "tomato sauce", "cream", "pasta"]), ("Add the drained pasta to the tomato sauce and stir to coat the pasta with the sauce. The sauce should be thick enough to coat the pasta; continue to stir and reduce if needed.", ["tomato sauce", "pasta", "sauce"]), ("Turn off the heat and sprinkle Parmigiano-Reggiano over the pasta and toss to coat evenly.", ["parmigiano reggiano", "pasta"]), ("Just before serving, thinly slice or tear up the basil leaves. Divide pasta among 4 serving platters.", ["fresh basil", "pasta"]), ("Garnish with a sprinkling of Parmigiano-Reggiano and basil.", ["parmigiano reggiano", "basil"])]
        
        XCTAssert(result.getIngredients() == ingredientTruth)
        XCTAssert(result.getIngredientsWithAmounts() == ingredientAmountTruth)
        for (left, right) in zip(result.getRecipeSteps(), stepsTruth){
            XCTAssert(left == right)
        }
    }

}
