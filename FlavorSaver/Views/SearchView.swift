//
//  SearchView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI


struct SearchView: View {
  @EnvironmentObject var user: User
  @Environment(\.editMode) private var editMode
  @State private var searchText = ""
  @State var selectedIngredients : [String] = []
  @StateObject var search : Search = Search()
  @StateObject var searchRecs : Recommended = Recommended()
  @State var recommendedRecipes: [Recipe] = []
  
  
  var body: some View {
    NavigationStack {
      VStack {
        ZStack{
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
                
                if selectedIngredients.contains(ingredient) {
                  Image(systemName: "checkmark")
                    .foregroundColor(.blue)
                }
              }
            }
          }
          .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by ingredient, dish, or cuisine")
          .navigationTitle(Text("Find a recipe"))
          .scrollDisabled(true) //NOT SURE IF THIS IS CODE ISSUE OR API ISSUE
          
          
          if searchText.isEmpty && selectedIngredients.isEmpty {
            VStack {
              HStack{
                Text("Recommended Recipes")
                  .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
              }
              .padding()
              VStack{
                ScrollView{
                  VStack{
                    ForEach(recommendedRecipes, id: \.self){ recipe in
                      RecipeCardLarge(recipe: recipe)
                    }
                  }
                }
                .refreshable {
                  await searchRecs.executeRandomSearch()
                  recommendedRecipes = searchRecs.getRecommendedRecipes()
                }
                .listStyle(.plain)
              }
            }
          }
          
          
        }
        
        //    MARK: selected ingredients and Done button
        HStack{
          ScrollView(.horizontal, showsIndicators: false){
            HStack{
              ForEach(selectedIngredients, id: \.self){ ingredient in
                Button(action: {
                }, label: {
                  HStack{
                    Text(ingredient)
                    Button(action: {
                      toggleSelection(ingredient)
                    }, label: {
                      Image(systemName: "xmark")
                    })
                  }
                })
                .buttonStyle(.bordered)
                .foregroundStyle(Color.black)
              }
            }
          }
          Spacer()
          
          NavigationLink(destination: SearchResultsView(search: search).environmentObject(user), label: {Text("Done")})
            .buttonStyle(.borderedProminent)
            .frame(alignment: .trailing)
            .disabled(selectedIngredients.isEmpty)
        }
        .padding()
      }/*.padding(.vertical, 32)*/
    }
    .navigationBarBackButtonHidden(true)
    .ignoresSafeArea(.all)
  }
  var searchResults: [String] {
    return search.getIngredientOptions(searchText)
  }
  
  func toggleSelection(_ ingredient: String) {
    if selectedIngredients.contains(ingredient)  {
      selectedIngredients = selectedIngredients.filter{ $0 != ingredient }
      search.removeIngredient(ingredient)
    } else {
      selectedIngredients.append(ingredient)
      search.addIngredient(ingredient)
    }
  }
}



#Preview {
  SearchView()
}
