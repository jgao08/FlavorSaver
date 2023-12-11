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
    @State private var folderSelect = false
    
    var body: some View  {
        Button(action: {
//            if user.isRecipeSaved(recipeID: recipe.id) {
//                user.removeSavedRecipe(recipe: recipe)
//            } else {
//                user.addSavedRecipe(recipe: recipe)
//            }
            folderSelect = true
        }, label: {
            if user.isRecipeSaved(recipeID: recipe.id) {
                HStack {
                    Image(systemName: "heart.fill")
                    Text("Recipe Saved")
                }
                .foregroundColor(.black)

            } else {
                HStack {
                    Image(systemName: "heart")
                    Text("Save Recipe")
                }
                .foregroundColor(.black)

            }
        })
        .sheet(isPresented: $folderSelect, content: {
            FolderSelectView(recipe: recipe).environmentObject(user)
        })
        .tint(user.isRecipeSaved(recipeID: recipe.id) ? .orange : .white)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .shadow(radius: 10)
    }
}

//#Preview {
//    SaveButton()
//}
