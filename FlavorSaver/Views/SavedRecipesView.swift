//
//  SavedRecipes.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation
import SwiftUI

struct SavedRecipesView: View {
    @EnvironmentObject var user: User
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View  {
        ScrollView {
            Text("Saved Recipes")
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(user.getSavedRecipes(), id: \.self) { recipe in
                    RecipeCardSmall(recipe: recipe)
                }
            }
            .padding(.horizontal)
            .padding()
        }
    }
}


