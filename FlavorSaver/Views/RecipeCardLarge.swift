//
//  RecipeCardSmall.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation
import SwiftUI

struct RecipeCardLarge: View {
//  @Binding var RecipeInfo: Recipe_Info
    
    var recipe: Recipe
  
  var body: some View  {
    ZStack{
        AsyncImage(url: URL(string: recipe.image))
//            .resizable()
//            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 400)
            .clipped()
            .cornerRadius(10)
        
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.6)]), startPoint: .top, endPoint: .bottom))
            .frame(width: 300, height: 400)
            .cornerRadius(10)


        HStack() {
            VStack(alignment: .leading, spacing: 4) {
                HStack() {
                    Text(recipe.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)

                    Spacer()
                    SaveIcon()
                }
                HStack(spacing: 4) {
                    Text(String(recipe.readyInMinutes))
                    Text("mins")
                    Text("•")
                    Text(recipe.cuisines.joined(separator: ", "))
                }
                .font(.caption)
                
                Spacer()
                
                Text(recipe.author)
                    .font(.caption)
            }
            .shadow(color: .black, radius: 8)
            
            Spacer()
        }
        .padding(24)
        .foregroundStyle(.white)
        .frame(width: 300, height: 400)
    }
  }
}

//#Preview {
////    RecipeCardLarge()
//}
