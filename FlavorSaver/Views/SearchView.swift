//
//  SearchView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI

struct SearchView: View{
  let ingredients = ["apple pie", "apple", "artichoke"]
  @State private var selectedIngs = ["almond", "banana"]
  @State private var searchText = ""

  var body: some View {
    VStack{
//    MARK: Top bar including selected ingredients and Done button
      HStack{
        Spacer()
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
        Spacer()
        Button("Done",
          action: {})
          .buttonStyle(.borderedProminent)
          .frame(alignment: .trailing)
        Spacer()
      }
      
//    MARK: Searched ingredient list
      NavigationView{
        List{
          ForEach(ingredients, id: \.self){ ingredient in
            Button(action: {
              selectedIngs.append(ingredient)
            }){
              Text(ingredient)
            }
          }
        }
      }.searchable(text: $searchText)
    }
  }
}

#Preview {
  SearchView()
}
