//
//  SearchResultsView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
  @Binding var selectedIngs: [String]
  
  var body: some View  {
    NavigationStack{
      VStack{
        ForEach(selectedIngs, id: \.self){ ingredient in
          Text(ingredient)
        }
        NavigationLink(destination: RecipeView(), label: {
            Text("Go to Recipe")
        })
        .buttonStyle(.bordered)
      }
    }
  }
}

