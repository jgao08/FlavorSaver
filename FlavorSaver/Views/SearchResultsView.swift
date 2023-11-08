//
//  SearchResultsView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @ObservedObject var search: Search
  @State var recipes : [Recipe] = []
  @EnvironmentObject var user: User

  
  var body: some View  {
    NavigationStack {
      VStack {
        HStack{
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
          Spacer()
          
          Button(action: {
            self.presentationMode.wrappedValue.dismiss()
          }, label: {
            Text("Edit")
          })
          .buttonStyle(.borderedProminent)
          .frame(alignment: .trailing)
        }
        .padding()
        
        HStack{
          Text("Recipes")
            .font(.title)
          Spacer()
        }
        
        
        HStack {
          ScrollView (.horizontal, showsIndicators: false ){
            HStack{
//              replace user.getSavedRecipes() with search.getRecipes(), but search.getRecipes() doesn't show anything
              ForEach(user.getSavedRecipes(), id: \.self){ recipe in
                RecipeCardLarge(recipe: recipe)
              }
              .task{
                await search.executeSearch()
                recipes = search.getRecipes()
                print(recipes)
              }
            }
          }
        }.padding(.horizontal)
        Spacer()
      }
    }
    .navigationBarBackButtonHidden()
    .navigationBarTitleDisplayMode(.inline)
  }
}


#Preview {
  SearchView()
}
