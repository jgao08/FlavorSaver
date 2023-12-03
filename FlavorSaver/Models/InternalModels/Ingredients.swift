//
//  Ingredients.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 11/4/23.
//

import Foundation

// TODO: Figure out a more efficient way to approach this (26 buckets for each starting letter?)
class Ingredients {
    // REQUIRES: Input is comprised of all lowercase letters
    //           Input is non-empty
    func filterIngredients(_ input : String) -> [String]{
        let firstCharacter : Character = input.first!
        
        guard let searchDict = ingredients[firstCharacter] else{
            return []
        }
        var results = searchDict.filter({$0.contains(input)}).sorted()
        if (results.count < 12 && !results.contains(input)){
            results.append(input)
        }
        return results
    }
    
    init(){
        ingredients = [:]
        for letter in "abcdefghijklmnopqrstuvwxyz"{
            ingredients[letter] = []
        }
        
        do {
            let path = Bundle.main.path(forResource: "ingredients", ofType: "txt")
            let content = try String(contentsOfFile: path!, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            for line in lines {
                guard !line.isEmpty else { continue }
                let firstCharacter = line.lowercased().first!
                ingredients[firstCharacter]!.append(line)
            }
        } catch {
            print("Error reading file: \(error)")
        }
        
        for extra in cuisines + mealTypes {
            let firstCharacter = extra.first!
            ingredients[firstCharacter]!.append(extra)
        }
    }
    
    let cuisines = ["african", "asian", "american", "british", "cajun", "caribbean", "chinese", "eastern", "european", "european", "french", "german", "greek", "indian", "irish", "italian", "japanese", "jewish", "korean", "latin", "american", "mediterranean", "mexican", "middle", "eastern", "nordic", "southern", "spanish", "thai", "vietnamese"]
    
    let mealTypes = ["main course", "side dish", "dessert", "appetizer", "salad", "bread", "breakfast", "soup", "beverage", "sauce", "marinade", "fingerfood", "snack", "drink"]
    
    var ingredients : [Character : [String]]
    
}
