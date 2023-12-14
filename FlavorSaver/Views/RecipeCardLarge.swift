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
                            .frame(width: 300, height: 400)
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        // Since the AsyncImagePhase enum isn't frozen,
                        // we need to add this currently unused fallback
                        // to handle any new cases that might be added
                        // in the future:
                        EmptyView()
                    }
                }
                
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.6)]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 300, height: 400)
                    .cornerRadius(10)
                
                
                HStack() {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .top) {
                            Text(recipe.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)

                            
                            Spacer()
                            SaveIcon(recipe: recipe).environmentObject(user)
                                .foregroundColor(.black)
                        }
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
                    .foregroundColor(.white)

                    
                    Spacer()
                }
                .padding(24)
                .frame(width: 300, height: 400)
            }
        })
//        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
////    RecipeCardLarge()
//}
