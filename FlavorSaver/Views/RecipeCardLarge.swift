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
    
    let imageURL = URL(string: "https://spoonacular.com/recipeImages/633975-556x370.jpg")
    let recipeName = "Cheeseburger"
    let readyInMinutes = 50
    let cuisines = ["American, French"]
    let author = "Gordon Ramsay"
  
  var body: some View  {
    ZStack{
        Image("ImageTest")
            .resizable()
            .aspectRatio(contentMode: .fill)
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
                    Text(recipeName)
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    SaveIcon()
                }
                HStack(spacing: 4) {
                    Text(String(readyInMinutes))
                    Text("mins")
                    Text("•")
                    Text(cuisines.joined(separator: ", "))
                }
                .font(.caption)
                
                Spacer()
                
                Text(author)
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

#Preview {
    RecipeCardLarge()
}
