//
//  SearchResultsView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
  @State var inputs: Search
  @State var ingredients: [String]
  
  
  var body: some View  {
    var recipes : [Recipe] = []
    let search : Search = enterIngredientsToSearch()

    NavigationStack{
      VStack{
        Text("Fetched Data: ")
        List(recipes, id: \.id){ recipe in
          Text(recipe.name)
        }
        .task {
          recipes = await search.getRecipes()
//          print(search.getMetaData().offset)
        }
      }
      NavigationLink(destination: RecipeView(recipeSearch: RecipeSearch(recipeID: 640026)), label: {
        Text("Go to Recipe")
      })
      .buttonStyle(.bordered)
    }
  }
  
  func enterIngredientsToSearch() -> Search {
    ingredients.forEach{ ingredient in
      inputs.addIngredient(ingredient)
    }
    return inputs
  }
}



