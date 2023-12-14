//
//  FolderSelectView.swift
//  FlavorSaver
//
//  Created by Erica Fu on 12/3/23.
//

import Foundation
import SwiftUI

struct FolderSelectView: View {
    
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode
    
    var recipe: Recipe
    @State private var selectedFolder: String?
    
    var body: some View {
        VStack {
            HStack (spacing: 4) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.automatic)
                Spacer()
                Text("Add to Folder")
                    .font(.headline)
                Spacer()
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.automatic)
                
            }.padding(.vertical, 16)
            .padding(.horizontal, 16)
            
            HStack (spacing: 16) {
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                VStack (alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Text(recipe.dishTypes.joined(separator: ", "))
                        .lineLimit(1)
                }
                Spacer()
            }.padding(.horizontal, 16)
            
            List {
                HStack (spacing: 16) {
                    AddFolderButton(recipe: recipe).environmentObject(user)
                    Text("Add Folder")
                }
                ForEach(user.getSavedRecipeFolders(), id: \.self) { folder in
                    Button(action: {
                        if !user.isRecipeSavedInFolder(recipeID: recipe.id, folderName: folder.name) {
                            user.addRecipeToFolder(recipe: recipe, folderName: folder.name)
                            selectedFolder = folder.name
                            print("recipe added to folder", folder.name)
                        } else {
                            user.removeRecipeFromFolder(recipe: recipe, folderName: folder.name)
                            selectedFolder = folder.name
                            selectedFolder = nil
                            print("recipe removed from folder", folder.name)

                        }
                    }){
                        HStack{
                            Text(folder.name)
                            Spacer()
                            
                            Image(systemName: "checkmark")
                                .foregroundColor(user.isRecipeSavedInFolder(recipeID: recipe.id, folderName: folder.name) || selectedFolder == folder.name ? .blue : .clear)
                        }
                    }
                }
            }
        }.tint(.blue)
    }
}
