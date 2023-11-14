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
    @State var recipes: [Recipe] = []
    
    
    var body: some View  {
        NavigationStack {
            VStack {
                RecipeSearchNavigation(search: search)

                if recipes == [] {
                    ContentUnavailableView.search
                } else {
                    RecipeSearchResultsRow(recipes: recipes)
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
        }
        .task{
            await search.executeSearch()
            recipes = search.getRecipes()
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
                        .foregroundStyle(Color.black)
                    }
                }
            }
        }
        .padding()
    }
}

struct RecipeSearchResultsRow: View {
    
    @State var recipes: [Recipe] = []
    var body: some View {
        HStack{
            Text("Recipes")
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
        }.padding(.horizontal)
    }
}


#Preview {
    SearchView()
}
