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
                    Text(recipe.name)
                }
                .task {
                    await search.executeSearch()
                }
            }

            NavigationLink(destination: RecipeView(recipeSearch: RecipeSearch(recipeID: 640026)), label: {
                Text("Go to Recipe")
            })
            .buttonStyle(.bordered)
        }
    }
}


