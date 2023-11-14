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
//        GridItem(.flexible(), spacing: 16),
//        GridItem(.flexible(), spacing: 16)
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View  {
        ScrollView {
            Text("Saved Recipes")
                .font(.headline)
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(user.getSavedRecipes(), id: \.self) { recipe in
                    RecipeCardSmall(recipe: recipe).environmentObject(user)
                }
            }
            .padding(.horizontal)
        }
    }
}


