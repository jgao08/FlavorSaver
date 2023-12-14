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
    @EnvironmentObject var user: User
    var recipe: Recipe
    
    var body: some View  {
        NavigationLink (destination: RecipeView(recipe: recipe).environmentObject(user), label: {
            
            ZStack{
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 170, height: 230)
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.6)]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 170, height: 230)
                    .cornerRadius(10)
                
                
                HStack() {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(recipe.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 4) {
                            Text(String(recipe.readyInMinutes))
                            Text("mins")
                            if recipe.cuisines != [] {
                                Text("•")
                            }
                            Text(recipe.cuisines.joined(separator: ", "))
                                .lineLimit(1)
                        }
                        .font(.caption)
                        Spacer()
                        
                        Text(recipe.author)
                            .font(.caption)
                    }
                    .modifier(TextShadow())
                    
                    Spacer()
                }
                .padding(16)
                .foregroundColor(.white)
                .frame(width: 170, height: 230)
            }
        })
    }
}

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}
