//
//  SearchResultsView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
    
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var search: Search
    @State var recipes: [(String, [Recipe])] = []
    @State var recipeResultsReceived: Bool = false
    
    
    var body: some View  {
        NavigationStack {
            VStack {
                RecipeSearchNavigation(search: search)
                
                if recipes.isEmpty && recipeResultsReceived {
                    ContentUnavailableView.search
                } else if recipeResultsReceived {
                    ScrollView {
                        VStack(spacing: 32) {
                            ForEach(recipes, id: \.0){ (tag, taggedRecipes) in
                                RecipeSearchResultsRow(tag: tag, recipes: taggedRecipes)
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
        }
        .task{
            await search.executeSearch()
            recipes = search.getRecipesWithTags()
            recipeResultsReceived = true
        }
    }
}

struct RecipeSearchNavigation: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var search: Search
    
    var body: some View {
        HStack{
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Edit")
            })
            .buttonStyle(.borderedProminent)
            .frame(alignment: .trailing)
            
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(search.getCurrentSelectedIngredients(), id: \.self){ ingredient in
                        Button(action: {
                        }, label: {
                            Text(ingredient)
                        })
                        .buttonStyle(.bordered)
                        .foregroundStyle(.black)
                    }
                }
            }
        }
        .padding()
    }
}

struct RecipeSearchResultsRow: View {
    @State var tag: String
    @State var recipes: [Recipe]
    var body: some View {
        VStack(spacing: 16){
            HStack{
                Text(tag.firstUppercased)
                    .font(.title)
                Spacer()
            }
            .padding(.horizontal)
            
            
            HStack {
                ScrollView (.horizontal, showsIndicators: false ){
                    HStack{
                        ForEach(recipes, id: \.self){ recipe in
                            RecipeCardLarge(recipe: recipe)
                        }
                    }
                }
                .scrollClipDisabled()
            }.padding(.horizontal)
        }
    }
}


extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
