//
//  Recipe_Info.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/3/23.
//

import Foundation

struct Recipe : Codable, Equatable, Hashable, Identifiable {
    // Retrieves the ingredients with just their name (without amounts)
    func getIngredients() -> [String]{
        return ingredientInfo.map{$0.originalName}
    }
    
    // Retrieves the ingredients of the recipe with their corresponding amounts
    func getIngredientsWithAmounts() -> [String]{
        return ingredientInfo.map{$0.original}
    }
    
    // @returns : A list of tuples representing the (Instruction, [Ingredients]) of a particular step
    // The list is returned in the order of the steps.
    func getRecipeSteps() -> [(String,[String])] {
        var result : [(String,[String])] = []
        
        for ingredientStep in ingredientSteps {
            for step in ingredientStep.steps {
                let stepSentences = step.step
                var stepIngredients : [String] = []
                for ingredient in step.ingredients {
                    stepIngredients.append(ingredient.name)
                }
                result.append((stepSentences, stepIngredients))
            }
        }
        return result
    }
    
    // @returns : A list of tuples representing the (Index, Instruction, [Ingredients]) of a particular step
    // The list is returned in the order of the steps.
    func getRecipeStepsWithAmounts() -> [(Int, String,[String])] {
        var result : [(Int, String,[String])] = []
        let ingredientsWithAmounts = getIngredientsWithAmounts()
        var stepIndex: Int = 1
        
        for ingredientStep in ingredientSteps {
            for step in ingredientStep.steps {
                let stepSentences = step.step
                var stepIngredients : [String] = []
                for ingredient in step.ingredients {
                    let ingredientWithAmount: String = ingredientsWithAmounts.filter{ $0.lowercased().contains(ingredient.name) }.first ?? ingredient.name
                    stepIngredients.append(ingredientWithAmount)
                }
                result.append((stepIndex, stepSentences, stepIngredients))
                stepIndex += 1
            }
        }
        return result
    }
    
    let id : Int
    let name : String
    let image : String
    let imageType : String
    
    let servings : Int
    let readyInMinutes : Int
    let author : String
    let authorURL : String
    let spoonURL : String
    let summary : String
    
    let cuisines : [String]
    let dishTypes : [String]
    let ingredientInfo : [Ingredient]
    let ingredientSteps : [RecipeInstructions]
    
    enum CodingKeys: String, CodingKey{
        case id
        case name = "title"
        case image
        case imageType
        case servings
        case readyInMinutes
        case author = "sourceName"
        case authorURL = "sourceUrl"
        case spoonURL = "spoonacularSourceUrl"
        case summary
        case cuisines
        case dishTypes
        case ingredientInfo = "extendedIngredients"
        case ingredientSteps = "analyzedInstructions"
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.image == rhs.image &&
        lhs.imageType == rhs.imageType &&
        lhs.servings == rhs.servings &&
        lhs.readyInMinutes == rhs.readyInMinutes &&
        lhs.author == rhs.author &&
        lhs.authorURL == rhs.authorURL &&
        lhs.spoonURL == rhs.spoonURL &&
        lhs.summary == rhs.summary &&
        lhs.cuisines == rhs.cuisines &&
        lhs.dishTypes == rhs.dishTypes
    }
}

struct Samples {
    let sampleRecipes = [Recipe(
        id: 1095931,
        name: "Matcha Smoothie",
        image: "https://spoonacular.com/recipeImages/1095931-556x370.jpg",
        imageType: "jpg",
        servings: 1,
        readyInMinutes: 2,
        author: "Foodista",
        authorURL: "https://www.foodista.com/recipe/KKTMW27V/matcha-smoothie",
        spoonURL: "https://spoonacular.com/matcha-smoothie-1095931",
        summary: "The recipe Matcha Smoothie can be made <b>in approximately 2 minutes</b>. One serving contains...",
        cuisines: [],
        dishTypes: ["morning meal", "brunch", "beverage", "breakfast", "drink"],
        ingredientInfo: [
            Ingredient(
                id: 9040,
                name: "banana",
                amount: 0.5,
                original: "1/2 banana",
                originalName: "banana",
                unit: ""
            ),
            Ingredient(
                id: 99212,
                name: "vanilla low-fat greek yogurt",
                amount: 6,
                original: "1 (6-ounce) vanilla low-fat greek yogurt",
                originalName: "vanilla low-fat greek yogurt",
                unit: "ounce"
            ),
            Ingredient(
                id: 98932,
                name: "matcha powder",
                amount: 1,
                original: "1 teaspoon matcha powder",
                originalName: "matcha powder",
                unit: "teaspoon"
            ),
            Ingredient(
                id: 12195,
                name: "almond butter",
                amount: 1.5,
                original: "1 1/2 tablespoons almond butter",
                originalName: "almond butter",
                unit: "tablespoons"
            ),
            Ingredient(
                id: 9087,
                name: "date, pitted",
                amount: 1,
                original: "1 date, pitted",
                originalName: "date, pitted",
                unit: ""
            ),
            Ingredient(
                id: 93607,
                name: "almond milk",
                amount: 0.5,
                original: "1/2 cup almond milk",
                originalName: "almond milk",
                unit: "cup"
            ),
            Ingredient(
                id: 10014412,
                name: "ice",
                amount: 1,
                original: "1 cup ice",
                originalName: "ice",
                unit: "cup"
            )
        ],
        ingredientSteps: [
            RecipeInstructions(
                name: "",
                steps: [
                    RecipeStep(
                        number: 1,
                        step: "Add the banana, yogurt, matcha powder, almond butter, date, almond milk and ice to a blender.",
                        ingredients: [
                            StepIngredient(id: 12195, name: "almond butter"),
                            StepIngredient(id: 98932, name: "matcha"),
                            StepIngredient(id: 93607, name: "almond milk"),
                            StepIngredient(id: 9040, name: "banana"),
                            StepIngredient(id: 99212, name: "vanilla low-fat greek yogurt"),
                            StepIngredient(id: 9087, name: "dates"),
                            StepIngredient(id: 10014412, name: "ice")
                        ]
                    ),
                    RecipeStep(number: 2, step: "Serve immediately.", ingredients: [])
                ]
            )
        ]
    ), Recipe(
        id: 634021,
        name: "Banana Butter Pie",
        image: "https://spoonacular.com/recipeImages/634021-556x370.jpg",
        imageType: "jpg",
        servings: 5,
        readyInMinutes: 45,
        author: "Foodista",
        authorURL: "http://www.foodista.com/recipe/GJ43JZQD/banana-butter-pie",
        spoonURL: "https://spoonacular.com/banana-butter-pie-634021",
        summary: "Banana Butter Pie might be just the dessert you are searching for. This recipe serves 5 and costs $1.33 per serving. One serving contains 840 calories, 7g of protein, and 59g of fat. Only a few people made this recipe, and 1 would say it hit the spot. Head to the store and pick up all-purpose flour, bananas, lemon peel from one lemon, and a few other things to make it today. From preparation to the plate, this recipe takes roughly 45 minutes. It is brought to you by Foodista. Taking all factors into account, this recipe earns a spoonacular score of 30%, which is rather bad.",
        cuisines: [],
        dishTypes: ["dessert"],
        ingredientInfo: [
            Ingredient(
                id: 20081,
                name: "all-purpose flour",
                amount: 15,
                original: "15 grams All-purpose flour",
                originalName: "All-purpose flour",
                unit: "grams"
            ),
            Ingredient(
                id: 9040,
                name: "bananas",
                amount: 5,
                original: "5 Bananas",
                originalName: "Bananas",
                unit: ""
            ),
            Ingredient(
                id: 1001,
                name: "butter",
                amount: 50,
                original: "50 grams Melted Butter",
                originalName: "Melted Butter",
                unit: "grams"
            ),
            Ingredient(
                id: 1001,
                name: "butter",
                amount: 60,
                original: "60 grams Butter",
                originalName: "Butter",
                unit: "grams"
            ),
            Ingredient(
                id: 1001,
                name: "butter",
                amount: 200,
                original: "200 grams Melted butter",
                originalName: "Melted butter",
                unit: "grams"
            ),
            Ingredient(
                id: 1123,
                name: "egg",
                amount: 1,
                original: "1 Egg",
                originalName: "Egg",
                unit: ""
            ),
            Ingredient(
                id: 93740,
                name: "ground almonds",
                amount: 30,
                original: "30 grams Ground almonds",
                originalName: "Ground almonds",
                unit: "grams"
            ),
            Ingredient(
                id: 9152,
                name: "lemon juice",
                amount: 0.75,
                original: "3/4 tablespoon Lemon juice",
                originalName: "Lemon juice",
                unit: "tablespoon"
            ),
            Ingredient(
                id: 9156,
                name: "lemon peel",
                amount: 0.5,
                original: "1/2 Lemon peel from one lemon",
                originalName: "Lemon peel from one lemon",
                unit: ""
            ),
            Ingredient(
                id: 10018173,
                name: "marie biscuits",
                amount: 200,
                original: "200 grams Marie Biscuits, ground",
                originalName: "Marie Biscuits, ground",
                unit: "grams"
            ),
            Ingredient(
                id: 11114037,
                name: "rum",
                amount: 1,
                original: "1 teaspoon Rum",
                originalName: "Rum",
                unit: "teaspoon"
            ),
            Ingredient(
                id: 19335,
                name: "sugar",
                amount: 35,
                original: "35 grams Sugar",
                originalName: "Sugar",
                unit: "grams"
            ),
            Ingredient(
                id: 19335,
                name: "sugar",
                amount: 40,
                original: "40 grams Sugar",
                originalName: "Sugar",
                unit: "grams"
            )
        ],
        ingredientSteps: [
            RecipeInstructions(
                name: "For the crust",
                steps: [
                    RecipeStep(
                        number: 1,
                        step: "Combine the marie biscuits and melted butter in a large bowl and press into a 23cm (lined and greased) pie tray and put in the refrigerator for later use.",
                        ingredients: [
                            StepIngredient(id: 10018173, name: "marie biscuits"),
                            StepIngredient(id: 1001, name: "butter")
                        ]
                    ),
                    RecipeStep(
                        number: 2,
                        step: "Pour half of the cake filling into the pie tray, then arrange sliced banana over it and cover with the balance cake filling.",
                        ingredients: [
                            StepIngredient(id: 0, name: "cake filling"),
                            StepIngredient(id: 9040, name: "banana")
                        ]
                    )
                ]
            ),
            RecipeInstructions(
                name: "Bake at 160C for about 40-45 mins",
                steps: [
                    RecipeStep(
                        number: 3,
                        step: "Bake at 160C for about 40-45 mins. Put banana butter pie in the fridge for at least one hour before serving.",
                        ingredients: [
                            StepIngredient(id: 9040, name: "banana"),
                            StepIngredient(id: 1001, name: "butter")
                        ]
                    )
                ]
            )
        ]
    ), Recipe(
        id: 633975,
        name: "Banana Almond Cake",
        image: "https://spoonacular.com/recipeImages/633975-556x370.jpg",
        imageType: "jpg",
        servings: 12,
        readyInMinutes: 45,
        author: "Foodista",
        authorURL: "http://www.foodista.com/recipe/HT52W5YX/banana-almond-cake",
        spoonURL: "https://spoonacular.com/banana-almond-cake-633975",
        summary: "Bananan Almond Cake might be just the dessert you are searching for. This recipe serves 12. One portion of this dish contains about 6g of protein, 7g of fat, and a total of 235 calories. For 34 cents per serving, this recipe covers 10% of your daily requirements of vitamins and minerals. 1 person found this recipe to be yummy and satisfying. From preparation to the plate, this recipe takes about 45 minutes. Head to the store and pick up flour, brown sugar, buttermilk, and a few other things to make it today. It is brought to you by Foodista. Taking all factors into account, this recipe earns a spoonacular score of 37%, which is rather bad. Try [Bananan Almond Cake](https://spoonacular.com/recipes/banana-almond-cake-49459), [Bananan Almond Snack Cake](https://spoonacular.com/recipes/banana-almond-snack-cake-49431), and [Almond Fudge Banana Cake](https://spoonacular.com/recipes/almond-fudge-banana-cake-125661) for similar recipes.",
        cuisines: [],
        dishTypes: ["dessert"],
        ingredientInfo: [
            Ingredient(id: 10112061, name: "almonds", amount: 0.5, original: "1/2 cup sliced almonds", originalName: "sliced almonds", unit: "cup"),
            Ingredient(id: 18369, name: "baking powder", amount: 5.5, original: "5 1/2 teaspoons baking powder", originalName: "baking powder", unit: "teaspoons"),
            Ingredient(id: 18372, name: "baking soda", amount: 0.5, original: "1/2 teaspoon baking soda", originalName: "baking soda", unit: "teaspoon"),
            Ingredient(id: 1009040, name: "banana", amount: 0.54545456, original: "6/11 cup mashed banana", originalName: "mashed banana", unit: "cup"),
            Ingredient(id: 19334, name: "brown sugar", amount: 3, original: "3 tablespoons Brown sugar, firmly packed", originalName: "Brown sugar, firmly packed", unit: "tablespoons"),
            Ingredient(id: 4073, name: "butter", amount: 3, original: "3 tablespoons Butter or margarine", originalName: "Butter or margarine", unit: "tablespoons"),
            Ingredient(id: 1230, name: "buttermilk", amount: 0.6666667, original: "2/3 cup buttermilk", originalName: "buttermilk", unit: "cup"),
            Ingredient(id: 1123, name: "eggs", amount: 3, original: "3 large eggs", originalName: "eggs", unit: "large"),
            Ingredient(id: 20081, name: "flour", amount: 1, original: "1 cup all-purpose flour", originalName: "all-purpose flour", unit: "cup"),
            Ingredient(id: 10719335, name: "granulated sugar", amount: 0.75, original: "3/4 cup granulated sugar", originalName: "granulated sugar", unit: "cup"),
            Ingredient(id: 1012010, name: "ground cinnamon", amount: 5.5, original: "5 1/2 teaspoons ground cinnamon", originalName: "ground cinnamon", unit: "teaspoons"),
            Ingredient(id: 2025, name: "ground nutmeg", amount: 0.25, original: "1/4 teaspoon ground nutmeg", originalName: "ground nutmeg", unit: "teaspoon"),
            Ingredient(id: 9216, name: "orange peel", amount: 2, original: "2 teaspoons grated orange peel", originalName: "grated orange peel", unit: "teaspoons"),
            Ingredient(id: 2047, name: "salt", amount: 1.5, original: "1 1/2 teaspoons salt", originalName: "salt", unit: "teaspoons"),
            Ingredient(id: 20080, name: "flour", amount: 1.5, original: "1 1/2 cups whole-wheat flour", originalName: "whole-wheat flour", unit: "cups"),
        ],
        ingredientSteps: [
            RecipeInstructions(
                name: "",
                steps: [
                    RecipeStep(number: 1, step: "Melt 1/4 cup of the butter.", ingredients: [
                        StepIngredient(id: 1001, name: "butter")
                    ]),
                    RecipeStep(number: 2, step: "Pour 2 tablespoons of the melted butter into an 8-cup bundt pan; brush the butter over pan sides and bottom.", ingredients: [
                        StepIngredient(id: 1001, name: "butter")
                    ]),
                    RecipeStep(number: 3, step: "Mix together the brown sugar, cinnamon, nutmeg, and almonds.", ingredients: [
                        StepIngredient(id: 19334, name: "brown sugar"),
                        StepIngredient(id: 2010, name: "cinnamon"),
                        StepIngredient(id: 12061, name: "almonds"),
                        StepIngredient(id: 2025, name: "nutmeg")
                    ]),
                    RecipeStep(number: 4, step: "Sprinkle bottom of pan with half the brown sugar mixture; combine the remaining mixture with the remaining melted butter; set aside.In a large bowl, beat remaining 1/4 cup butter with granulated sugar until blended. Beat in eggs, 1 at a time, until blended. Beat in orange peel and banana.", ingredients: [
                        StepIngredient(id: 10719335, name: "granulated sugar"),
                        StepIngredient(id: 19334, name: "brown sugar"),
                        StepIngredient(id: 9216, name: "orange zest"),
                        StepIngredient(id: 9040, name: "banana"),
                        StepIngredient(id: 1001, name: "butter"),
                        StepIngredient(id: 1123, name: "egg")
                    ]),
                    RecipeStep(number: 5, step: "Mix all-purpose and whole-wheat flours, baking powder, soda, and salt.", ingredients: [
                        StepIngredient(id: 18369, name: "baking powder"),
                        StepIngredient(id: 0, name: "wheat"),
                        StepIngredient(id: 2047, name: "salt"),
                        StepIngredient(id: 0, name: "pop")
                    ]),
                    RecipeStep(number: 6, step: "Add to banana mixture along with the buttermilk; stir until well blended.", ingredients: [
                        StepIngredient(id: 1230, name: "buttermilk"),
                        StepIngredient(id: 9040, name: "banana")
                    ]),
                    RecipeStep(number: 7, step: "Pour half the batter into prepared pan. Spoon remaining brown sugar mixture evenly over top; cover with remaining batter.", ingredients: [
                        StepIngredient(id: 19334, name: "brown sugar")
                    ]),
                    RecipeStep(number: 8, step: "Bake in a 350 degrees oven until a long wood skewer inserted into the thickest part of the cake comes out clean, about 50 minutes. Cool the cake on a rack about 5 minutes, then invert cake onto a serving plate.", ingredients: []),
                    RecipeStep(number: 9, step: "Serve the cake warm or cool. This recipe yields 12 servings. Comments: A bag of ripe bananas inspired Jan McHargue to create this coffee cake. You can enjoy the banana cake with its spicy brown sugar-almond topping and filling for brunch, with coffee, or for dessert.", ingredients: [
                        StepIngredient(id: 19334, name: "brown sugar"),
                        StepIngredient(id: 9040, name: "banana"),
                        StepIngredient(id: 12061, name: "almonds"),
                        StepIngredient(id: 14209, name: "coffee")
                    ])
                ]
            ),
        ]
    )
    ]
    
}
