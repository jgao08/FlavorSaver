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
//  @State var  = Set<String>()


  var body: some View {
    NavigationView{
      VStack{
        //    MARK: Searched ingredient list
        List(searchResults, id: \.self){ ingredient in
          HStack{
            Text(ingredient)
            Spacer()
            if selectedIngs.contains(ingredient) {
              Image(systemName: "checkmark")
                  .foregroundColor(.blue)
            }
          }
          .onTapGesture{
            toggleSelection(ingredient)
          }
        }
        .searchable(text: $searchText)
//        .environment(\.editMode, .constant(EditMode.active)) // Enable selection mode

        if searchText.isEmpty {
          Text("Search by ingredient, dish, or cuisine")
            .font(.title)
        }

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
              }
            }
          }
          Spacer()
          NavigationLink(destination: SearchResultsView(selectedIngs: self.$selectedIngs),label: {Text("Done")} )
            .buttonStyle(.borderedProminent)
            .frame(alignment: .trailing)
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
