//
//  ProfileView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI


struct ProfileView: View {
  @EnvironmentObject var user: User
  var imgName: String = ""
  
  var body: some View{
    NavigationStack{
      VStack{
        if user.profileID == 0 {
          imgName = "rat"
        } else if user.profileID == 1 {
          imgName = "raccoon"
        } else if user.profileID == 2 {
          imgName = "guy"
        }
        Image(imgName)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 100, height: 100)
          .clipShape(Circle())
        Text(user.getUsername())
          .font(.title)
          .bold()
        Divider()
        NavigationLink(destination: SavedRecipesView(), label: {
          VStack{
            HStack{
              Text("Saved Recipes")
                .font(.title)
              Spacer()
              Image(systemName: "chevron.right")
                .font(.title)
            }
            .foregroundStyle(Color.black)
            .padding()

            HStack {
                ScrollView (.horizontal, showsIndicators: false ){
                    HStack{
                      ForEach(user.getSavedRecipes(), id: \.self){ recipe in
                            RecipeCardLarge(recipe: recipe)
                        }
                    }
                }
            }.padding(.horizontal)
          }
          
        })
      }
    }
  }
}

#Preview {
  ProfileView()
}
