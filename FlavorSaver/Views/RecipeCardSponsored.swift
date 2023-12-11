//
//  RecipeCardSponsored.swift
//  FlavorSaver
//
//  Created by Erica Fu on 12/11/23.
//

import Foundation
import SwiftUI

struct RecipeCardSponsored: View {
    
    @EnvironmentObject var user: User
    var recipe: Recipe
    @State private var folderSelect: Bool = false
    
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
                            .clipped()
                            .frame(height: 450)
                            .containerRelativeFrame(.horizontal)
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
                    .frame(height: 450)
                    .containerRelativeFrame(.horizontal)

                    .cornerRadius(10)
                
                
                HStack() {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .top) {
                            Text(recipe.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)

                            
                            Spacer()
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
                        .font(.body)
                        
                        Text(recipe.author)
                            .font(.body)

                        Spacer()
                        
                        HStack (spacing: 16) {
                            NavigationLink (destination: RecipeView(recipe: recipe).environmentObject(user), label: {
                                Button("Try Now", systemImage: "arrow.forward") {
                                    
                                }
                                .foregroundColor(.black)
                                .tint(.white)
                                .controlSize(.large)
                                .buttonStyle(.borderedProminent)
                                .shadow(radius: 10)
                            })
                            
                            Button(action: {
                                folderSelect = true
                            }, label: {
                                if user.isRecipeSaved(recipeID: recipe.id) {
                                    HStack {
                                        Image(systemName: "heart.fill")
                                        Text("Recipe Saved")
                                    }
                                    .foregroundColor(.white)

                                } else {
                                    HStack {
                                        Image(systemName: "heart")
                                        Text("Save Recipe")
                                    }
                                    .foregroundColor(.white)


                                }
                            })
                            .tint(.gray)
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                            .shadow(radius: 10)
                            
                            .sheet(isPresented: $folderSelect, content: {
                                FolderSelectView(recipe: recipe).environmentObject(user)
                            })
                            
                        }

                    }
                    .shadow(color: .black, radius: 8)
                    .foregroundColor(.white)

                    
                    Spacer()
                }
                .padding(24)
                .frame(height: 450)
                .containerRelativeFrame(.horizontal)
                //                .frame(maxWidth: .infinity)
            }
        })
//        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
////    RecipeCardLarge()
//}
