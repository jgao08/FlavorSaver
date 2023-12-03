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

    var recipe: Recipe
    @State private var isNamingFolder: Bool = false
    @State private var folderName: String = ""
    
    var body: some View {
        VStack {
            HStack {
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
                Text(recipe.name)
                    .font(.headline)
            }
            Button {
                isNamingFolder.toggle()
            } label: {
                HStack {
                    Image(systemName: "plus")
                }
                Text("New Folder")
            }
            .alert("Log in", isPresented: $isNamingFolder) {
                TextField("Folder Name", text: $folderName)
                    .textInputAutocapitalization(.never)
                Button("Save", action: createFolder)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please enter your username and password.")
            }
            
            List(user.getSavedRecipeFolders(), id: \.self) { folder in
                Button(action: {
                    if user.addRecipeToFolder(recipe: recipe, folderName: folder.name)
//                    searchText = ""
                }){
                    HStack{
                        Text(folder.name)
                            .foregroundStyle(Color.black)
                        Spacer()
                        
                        if folder.recipes.contains(recipe) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
    
    func createFolder() {
        user.createFolder(name: folderName)
    }
}
