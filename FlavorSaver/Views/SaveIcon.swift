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
    @State var colorMode: Bool = true // if true: white, else: black
    @State private var folderSelect = false
    @State private var isSaved: Bool = false
    
    var body: some View  {
        Group {
            Button {
                // Change the saved properties in the backend here
                //            print("Edit button was tapped")
                //            if user.isRecipeSaved(recipeID: recipe.id) {
                //                user.removeSavedRecipe(recipe: recipe)
                //            } else {
                //                user.addSavedRecipe(recipe: recipe)
                //            }
                folderSelect = true
            } label: {
                if isSaved {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                } else {
                    Image(systemName: "heart")
                        .foregroundColor(colorMode ? .white : .black)
                        .font(.system(size: 24))
                }
            }
        }
        .sheet(isPresented: $folderSelect, content: {
            FolderSelectView(recipe: recipe).environmentObject(user)
        })
        .onChange(of: folderSelect) {
            isSaved = user.isRecipeSaved(recipeID: recipe.id)
        }
        .onAppear() {
            isSaved = user.isRecipeSaved(recipeID: recipe.id)
        }
    }
}

//#Preview {
//    SaveIcon()
//}

