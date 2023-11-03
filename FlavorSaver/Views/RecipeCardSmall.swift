//
//  RecipeCardSmall.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.

//  loading an image from URL reference
//  https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
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
        Image("ImageTest")
    }
  }
}

#Preview {
    RecipeCardSmall()
}
