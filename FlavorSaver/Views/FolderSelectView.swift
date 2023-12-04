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
    @State private var isNamingFolder: Bool = false
    @State private var folderName: String = ""
    
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
                //                    .foregroundColor(Color.black)
                Spacer()
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.automatic)
                
            }.padding(.top, 16)
                .padding(.horizontal, 16)
            
            HStack {
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
                        // Since the AsyncImagePhase enum isn't frozen,
                        // we need to add this currently unused fallback
                        // to handle any new cases that might be added
                        // in the future:
                        EmptyView()
                    }
                }
                VStack (alignment: .leading, spacing: 16) {
                    Text(recipe.name)
                        .font(.headline)
                        .foregroundStyle(Color.black)
                    ForEach(recipe.dishTypes, id: \.self) {tag in
                        Button(action: {}, label: {
                            Text(tag)
                        })
                        .buttonStyle(.bordered)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(Color.black)
                    }
                    
                }
                Spacer()
            }.padding(.horizontal, 16)
            
            Button {
                isNamingFolder.toggle()
            } label: {
                HStack {
                    Image(systemName: "plus")
                }
                Text("New Folder")
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .shadow(radius: 10)
            .alert("New Folder", isPresented: $isNamingFolder) {
                TextField("Name", text: $folderName)
                    .textInputAutocapitalization(.never)
                //                    .foregroundColor(Color.black)
                Button {
                    createFolder()
                    user.addRecipeToFolder(recipe: recipe, folderName: folderName)
                    isNamingFolder = false
                } label: {
                    Text("Save")
                }
                .disabled(folderName == "")
                
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Enter a name for this folder")
            }
            
            List(user.getSavedRecipeFolders(), id: \.self) { folder in
                Button(action: {
                    if !user.isRecipeSavedInFolder(recipeID: recipe.id, folderName: folder.name) {
                        user.addRecipeToFolder(recipe: recipe, folderName: folder.name)
                    } else {
                        user.removeRecipeFromFolder(recipe: recipe, folderName: folder.name)
                    }
                }){
                    HStack{
                        Text(folder.name)
                        //                            .foregroundStyle(Color.black)
                        Spacer()
                        
                        if user.isRecipeSavedInFolder(recipeID: recipe.id, folderName: folder.name) {
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
