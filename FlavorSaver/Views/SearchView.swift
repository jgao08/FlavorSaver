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
  @State private var isInitialLoad = true

  
  var body: some View {
    NavigationStack {
      VStack {
        ZStack{
          ScrollView{
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
//            .zIndex(1)
            
//            Spacer()
            if searchText.isEmpty {
              VStack {
                HStack{
                  Text("Recommended Recipes")
                    .font(.title)
                  Spacer()
                }
                .padding()
                HStack{
                  VStack{
                    ScrollView{
                      VStack{
                        ForEach(recommendedRecipes, id: \.self){ recipe in
                          RecipeCardLarge(recipe: recipe)
                        }
                      }
                    }
                    .scrollIndicators(.hidden)
                    .task {
                      if isInitialLoad{
                        await searchRecs.executeRandomSearch()
                        recommendedRecipes = searchRecs.getRecommendedRecipes()
                        isInitialLoad = false
                      }
                    }
                  }
                }
              }
//              .zIndex(1)
              Spacer()
            }
          }
          .refreshable {
            await searchRecs.executeRandomSearch()
            recommendedRecipes = searchRecs.getRecommendedRecipes()
          }
          .overlay{
            if !searchText.isEmpty {
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
    if !search.getIngredientOptions(searchText).isEmpty {
      print(search.getIngredientOptions(searchText))
    } else {
      print("no search results")
    }
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



//#Preview {
//  SearchView()
//}
