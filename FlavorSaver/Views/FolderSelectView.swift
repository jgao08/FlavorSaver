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
                //                    .foregroundColor(Color.black)
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
                        // Since the AsyncImagePhase enum isn't frozen,
                        // we need to add this currently unused fallback
                        // to handle any new cases that might be added
                        // in the future:
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
                Button(action: toggleNamingFolder) {
                    Label("Add Folder", systemImage: "folder.badge.plus")
                }
                .alert("New Folder", isPresented: $isNamingFolder) {
                    TextField("Name", text: $folderName)
                        .textInputAutocapitalization(.never)
                    
                    Button("Save") {
                        print("Save button clicked", folderName) // Moved print statement here
                        if createFolder() {
                            user.addRecipeToFolder(recipe: recipe, folderName: folderName)
                            isNamingFolder = false
                            print("Folder created", folderName)
                            folderName = "" // Reset folderName after successful folder creation
                        } else {
                            // Optionally handle the case when createFolder() returns false
                            print("Folder creation failed")
                        }
                    }
                    
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Enter a name for this folder")
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
                            //                            .foregroundStyle(Color.black)
                            Spacer()
                            
                            if user.isRecipeSavedInFolder(recipeID: recipe.id, folderName: folder.name) || selectedFolder == folder.name {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }.foregroundColor(.black)

//        .onChange(of: folderName) {
//            print("folder name changed", folderName)
//            if folderName == "" {
//                folderNameEmpty = true
//            } else {
//                folderNameEmpty = false
//            }
//        }
    }
    
    func createFolder() -> Bool {
        let folderCreated = user.createFolder(name: folderName)
        print("folder created", folderCreated)
        return folderCreated
    }
    
    func toggleNamingFolder() {
        isNamingFolder.toggle()
    }
}
