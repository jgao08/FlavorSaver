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
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack{
                    ScrollView{
                        VStack(spacing: 16) {
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
                            
                            if searchText.isEmpty {
                                RecipeCardSponsored(recipe: searchRecs.getRecommendedRecipes().last ?? Recipe(id: 0, name: "", image: "", imageType: "", servings: 0, readyInMinutes: 0, author: "", authorURL: "", spoonURL: "", summary: "", cuisines: [], dishTypes: [], ingredientInfo: [], ingredientSteps: [])).environmentObject(user)
                                    .padding(.horizontal, 16)
                                
                                VStack(spacing: 16){
                                    HStack{
                                        Text("Recommended Recipes")
                                            .font(.title)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    
                                    
                                    HStack {
                                        ScrollView (.horizontal, showsIndicators: false ){
                                            HStack{
                                                ForEach(searchRecs.getRecommendedRecipes(), id: \.self){ recipe in
                                                    RecipeCardLarge(recipe: recipe)
                                                }
                                            }
                                        }
                                        .scrollClipDisabled()
                                    }.padding(.horizontal)
                                }
                            }
                        }
                        Spacer()
                    }
                    .refreshable {
                        await searchRecs.executeRandomSearch()
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
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
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

