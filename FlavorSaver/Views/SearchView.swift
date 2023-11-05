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

  var body: some View {
    NavigationStack{
      VStack{
        if searchText.isEmpty {
          HStack{
            Text("Search by ingredient, dish, or cuisine")
              .font(.title)
          }
          .transition(.opacity.animation(.spring(duration: 1.0)))
        }
        
        //    MARK: Searched ingredient list
        List(searchResults, id: \.self){ ingredient in
          Button(action: {
            toggleSelection(ingredient)
            searchText = ""
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
              ForEach(selectedIngs, id: \.self){ ingredient in
                Button(action: {
                }, label: {
                  HStack{
                    Text(ingredient)
                    Image(systemName: "xmark").onTapGesture {
                      if let index = selectedIngs.firstIndex(where:{$0 == ingredient}){
                        selectedIngs.remove(at: index)
                      }
                    }
                  }
                })
                .buttonStyle(.bordered)
                .foregroundStyle(Color.black)
              }
            }
          }
          Spacer()
          
          NavigationLink(destination: SearchResultsView(selectedIngs: self.$selectedIngs), label: {Text("Done")})
            .buttonStyle(.borderedProminent)
            .frame(alignment: .trailing)
            .disabled(selectedIngs.isEmpty)
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
      selectedIngs.removeAll(where: { $0 == ingredient })
    } else {
      selectedIngs.append(ingredient)
    }
  }
}

#Preview {
  SearchView()
}
