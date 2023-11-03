//
//  RecipeCardSmall.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation
import SwiftUI

struct RecipeCardSmall: View {
//  @Binding var RecipeInfo: Recipe_Info
    
//    let servings : Int
//    let readyInMinutes : Int
//    let author : String
//    let authorURL : String
//    let spoonURL : String
//    let summary : String
//    
//    let cuisines : [String]
//    let dishTypes : [String]
//    let ingredientInfo : [Ingredient]
//    let ingredientSteps : [Recipe_Instructions]
    
    let imageURL = URL(string: "https://spoonacular.com/recipeImages/633975-556x370.jpg")
  
  var body: some View  {
    ZStack{
        DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
    }
  }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
