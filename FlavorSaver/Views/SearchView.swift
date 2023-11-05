//
//  SearchView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI


struct SearchView: View {
  @Environment(\.editMode) private var editMode
  var ingredients = ["apple pie", "apple", "artichoke", "jellybean", "almond", "banana"]
  @State private var selectedIngs: [String] = []
  @State private var searchText = ""
  @State public var selectedEmpty: Bool = true
    @State private var recipes : Search = Search()
//  @State var  = Set<String>()


  var body: some View {
    NavigationStack{
      VStack{
        if searchText.isEmpty {
          Text("Search by ingredient, dish, or cuisine")
            .font(.title)
        }
        
        //    MARK: Searched ingredient list
        List(searchResults, id: \.self){ ingredient in
          Button(action: {
            toggleSelection(ingredient)
          }){
            HStack{
              Text(ingredient)
                .foregroundStyle(Color.black)
              Spacer()
              if self.recipes.selectedIngredients.contains(ingredient) {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
              }
            }
          }
        }
        .searchable(text: $searchText)
        .navigationTitle(Text("Search"))

        
          //    MARK: selected ingredients and Done button
        HStack{
            ScrollView(.horizontal, showsIndicators: false){
              HStack{
                ForEach(self.recipes.selectedIngredients, id: \.self){ ingredient in
                  Button(action: {
                  }, label: {
                    HStack{
                      Text(ingredient)
                      Image(systemName: "xmark").onTapGesture {
                        if let index = self.recipes.selectedIngredients.firstIndex(where:{$0 == ingredient}){
                            self.recipes.selectedIngredients.remove(at: index)
                        }
                      }
                    }
                  })
                  .buttonStyle(.bordered)
                }
              }
            }
            Spacer()
          NavigationLink(destination: SearchResultsView(selectedIngs: self.$recipes.selectedIngredients), label: {Text("Done")})
              .buttonStyle(.borderedProminent)
              .frame(alignment: .trailing)
              .disabled(self.recipes.selectedIngredients.isEmpty)
          }
          .padding()
      }
    }
  }
  var searchResults: [String] { // change to [Ingredient] in future?
    return ingredients.filter{ $0.contains(searchText.lowercased()) }
  }
  
  func toggleSelection(_ ingredient: String) {
      if selectedIngs.contains(ingredient) {
          //selectedIngs.removeAll(where: { $0 == ingredient })
          recipes.removeIngredient(ingredient)
      } else {
        //selectedIngs.append(ingredient)
          recipes.addIngredient(ingredient)
      }
  }
}

#Preview {
  SearchView()
}
