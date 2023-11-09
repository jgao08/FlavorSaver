//
//  SaveButton.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation
import SwiftUI

struct SaveButton: View {
    @EnvironmentObject var user: User
    var recipe: Recipe
    
    var body: some View  {
        Button(action: {
            if user.isRecipeSaved(recipeID: recipe.id) {
                user.removeSavedRecipe(recipe: recipe)
            } else {
                user.addSavedRecipe(recipe: recipe)
            }
        }, label: {
            if user.isRecipeSaved(recipeID: recipe.id) {
                Image(systemName: "heart.fill")
                Text("Recipe Saved")
            } else {
                Image(systemName: "heart")
                Text("Save Recipe")
            }
        })
        .tint(user.isRecipeSaved(recipeID: recipe.id) ? .orange : .white)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .foregroundStyle(Color.black)
        .shadow(radius: 10)
    }
}

//#Preview {
//    SaveButton()
//}
