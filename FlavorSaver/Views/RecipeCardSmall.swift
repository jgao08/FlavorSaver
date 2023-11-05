//
//  RecipeCardSmall.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.

//  loading an image from URL reference
//  https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
//

import Foundation
import SwiftUI

struct RecipeCardSmall: View {
//  @Binding var RecipeInfo: Recipe_Info
    var recipe: Recipe
    
//    let imageURL = URL(string: "https://spoonacular.com/recipeImages/633975-556x370.jpg")
//    let recipeName = "Cheeseburger"
//    let readyInMinutes = 50
//    let cuisines = ["American, French"]
//    let author = "Gordon Ramsay"
  
  var body: some View  {
    ZStack{
        Image("ImageTest")
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 170, height: 230)
            .clipped()
            .cornerRadius(10)
        
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.6)]), startPoint: .top, endPoint: .bottom))
            .frame(width: 170, height: 230)
            .cornerRadius(10)


        HStack() {
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .fontWeight(.bold)
                HStack(spacing: 4) {
                    Text(String(recipe.readyInMinutes))
                    Text("mins")
                    Text("•")
                    Text(arrayToString(array: recipe.cuisines))
                        .lineLimit(1)
                }
                .font(.caption)
                
                Spacer()
                
                Text(recipe.author)
                    .font(.caption)
            }
            .shadow(color: .black, radius: 8)
            
            Spacer()
        }
        .padding(16)
        .foregroundStyle(.white)
        .frame(width: 170, height: 230)
    }
  }
}

//#Preview {
//    RecipeCardSmall()
//}
