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
        
//        ScrollView {
          VStack{
            List(search.getRecipes(), id: \.self){ recipe in
              RecipeCardLarge(recipe: recipe)
            }
          }
//        }
        
      }
    }
    .navigationBarBackButtonHidden()
    .navigationBarTitleDisplayMode(.inline)
  }
}


#Preview {
  SearchView()
}
