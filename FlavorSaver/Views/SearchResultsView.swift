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
  
  var body: some View  {
    var recipes : [Recipe] = []
    
    NavigationStack{
      VStack{
        Text("Fetched Data: ")
        List(recipes, id: \.id){ recipe in
          Text(recipe.name)
        }
        .onAppear{
          inputs.getRecipes(completion: {recipe_infos in
            recipes = recipe_infos
          })
        }
      }
      NavigationLink(destination: RecipeView(), label: {
        Text("Go to Recipe")
      })
      .buttonStyle(.bordered)
    }
  }
}



