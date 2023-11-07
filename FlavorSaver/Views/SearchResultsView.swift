//
//  SearchResultsView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var search: Search

    var body: some View  {
        NavigationStack {
            VStack {
                Text("Fetched Data:")
                List(search.getRecipes(), id: \.id) { recipe in
                  NavigationLink(destination: RecipeView(recipe: recipe), label:{
                    Text(recipe.name)
                  })
                }
                .task {
                    await search.executeSearch()
                  print(search.getCurrentSelectedIngredients())
                }
            }

//            NavigationLink(destination: RecipeView(recipeSearch: search), label: {
//                Text("Go to Recipe")
//            })
            .buttonStyle(.bordered)
        }
    }
}


