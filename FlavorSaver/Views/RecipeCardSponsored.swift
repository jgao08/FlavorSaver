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
                            .frame(width: UIScreen.main.bounds.width - 32, height: 450)
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.6)]), startPoint: .top, endPoint: .bottom))
                    .frame(width: UIScreen.main.bounds.width - 32, height: 450)
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
                                HStack {
                                    Image(systemName: "arrow.forward")
                                    Text("Try Now")
                                }
                                .buttonStyle(.borderedProminent)
                                
                                .padding(15)
                                .background(.white)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .modifier(TextShadow())
                            })
                            
                            Button(action: {
                                folderSelect = true
                            }, label: {
                                if user.isRecipeSaved(recipeID: recipe.id) {
                                    HStack {
                                        Image(systemName: "heart.fill")
                                        Text("Saved")
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
                            .modifier(TextShadow())
                            
                            .sheet(isPresented: $folderSelect, content: {
                                FolderSelectView(recipe: recipe).environmentObject(user)
                            })
                            .foregroundColor(.black)
                            
                            
                        }
                        
                    }
                    .modifier(TextShadow())
                    .foregroundColor(.white)
                    
                    
                    Spacer()
                }
                .padding(24)
                .frame(width: UIScreen.main.bounds.width - 32, height: 450)
            }
        })
        //        .buttonStyle(PlainButtonStyle())
    }
}
