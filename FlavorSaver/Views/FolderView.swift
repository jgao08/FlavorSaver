//
//  FolderView.swift
//  FlavorSaver
//
//  Created by Erica Fu on 12/3/23.
//

import Foundation
import SwiftUI

struct FolderView: View {
    @EnvironmentObject var user: User
    //    @Environment(\.dismiss) private var dismiss
    
    @Binding var folder: Folder
    @Binding var isShowingFolder: Bool
    
    @State private var showingEditFolder: Bool = false
    @State private var ordering: String = "Newest"
    @State private var isRenamingFolder : Bool = false
    @State private var newFolderName : String = ""
    
    private let columns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View  {
        ScrollView {
            VStack (alignment: .leading, spacing: 32) {
                VStack (alignment: .leading){
                    Text(folder.name)
                        .font(.title)
                        .bold()
                    Text("\(user.getSavedRecipes(folderName: folder.name).count) Recipes")
                        .font(.caption)
                        .foregroundColor(.gray)
                }.padding(.horizontal, 16)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(user.getSavedRecipes(folderName: folder.name), id: \.self) { recipe in
                        RecipeCardSmall(recipe: recipe).environmentObject(user)
                    }
                }
                .padding(.horizontal)
            }
        }
        .toolbar{
            ToolbarItem{
                Menu{
                    Button{
                        user.changeFolderOrdering(folderName: folder.name, ordering: "recentReverse")
                        ordering = "Newest"
                    } label: {
                        Text("Date created: newest")
                        //                Image(systemName: "checkmark")
                        //                  .foregroundColor(ordering == "recentReverse" ? .blue : .clear)
                    }
                    Button{
                        user.changeFolderOrdering(folderName: folder.name, ordering: "recent")
                        ordering = "Oldest"
                    } label: {
                        Text("Date created: oldest")
                        //                Image(systemName: "checkmark")
                        //                  .foregroundColor(ordering == "recent" ? .blue : .clear)
                    }
                    Button{
                        user.changeFolderOrdering(folderName: folder.name, ordering: "alphabeticalReverse")
                        ordering = "Alphabetical A-Z"
                    } label: {
                        Text("Alphabetical A-Z")
                        //                Image(systemName: "checkmark")
                        //                  .foregroundColor(ordering == "alphabeticalReverse" ? .blue : .clear)
                    }
                    Button{
                        user.changeFolderOrdering(folderName: folder.name, ordering: "alphabetical")
                        ordering = "Alphabetical Z-A"
                    } label: {
                        Text("Alphabetical Z-A")
                        //                Image(systemName: "checkmark")
                        //                  .foregroundColor(ordering == "alphabetical" ? .blue : .clear)
                    }
                } label: {
                    Text("Sort: \(ordering)")
                }
            }
            ToolbarItem{
                Button {
                    showingEditFolder = true
                } label: {
                    if(user.getUserID() != "oWkYfZMRPYYMC3hIAb5pW8jeg1a2"){
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
        .confirmationDialog("Folder Settings", isPresented: $showingEditFolder) {
            Button("Delete Folder", role: .destructive) {
                user.deleteFolder(folderName: folder.name)
                isShowingFolder = false
            }
            .foregroundColor(.red)
            
            Button("Edit Folder Name"){
                isRenamingFolder.toggle()
            }
        }.alert("New Folder Name", isPresented: $isRenamingFolder) {
            TextField("Enter a new name", text: $newFolderName).textInputAutocapitalization(.never)
            
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                user.renameFolder(oldName: folder.name, newName: newFolderName)
            }
        }
    }
}
