//
//  SaveIcon.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation
import SwiftUI

struct SaveIcon: View {
    //  @Binding var RecipeInfo: Recipe_Info
//    
//    @State var saved: Bool = false
//    @State var favorites: [String] = ["banana almond cake", "cheeseburger"]
//    var recipeName = "cheeseburger"
    
    @EnvironmentObject var user: User
    var recipe: Recipe
    
    var body: some View  {
        Button {
            // Change the saved properties in the backend here
            print("Edit button was tapped")
            if user.isRecipeSaved(recipeID: recipe.id) {
                user.removeSavedRecipe(recipe: recipe)
            } else {
                user.addSavedRecipe(recipe: recipe)
            }
        } label: {
            if user.isRecipeSaved(recipeID: recipe.id) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 24))
            } else {
                Image(systemName: "heart")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
            }
        }
    }
}

//#Preview {
//    SaveIcon()
//}

