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
    var recipe: Recipe
  
    var body: some View  {
        NavigationLink (destination: RecipeView(recipeSearch: recipe), label: {
            
            ZStack{
                AsyncImage(url: URL(string: recipe.image))
                //            .renderingMode(.original)
                //            .resizable()
                //            .aspectRatio(contentMode: .fill)
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
                            Text(recipe.cuisines.joined(separator: ", "))
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
        })
    }
}

//#Preview {
//    RecipeCardSmall()
//}

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}
