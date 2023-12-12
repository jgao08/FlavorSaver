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
    @State private var ordering: String = "recent"
    
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
                ordering = "recentReverse"
                print("AAAAAAA")
                print(ordering == "recentReverse")
              } label: {
                Text("Date created: newest")
                Image(systemName: "checkmark")
                  .foregroundColor(ordering == "recentReverse" ? .blue : .clear)
              }
              Button{
                user.changeFolderOrdering(folderName: folder.name, ordering: "recent")
                ordering = "recent"
              } label: {
                Text("Date created: oldest")
                Image(systemName: "checkmark")
                  .foregroundColor(ordering == "recent" ? .blue : .clear)
              }
              Button{
                user.changeFolderOrdering(folderName: folder.name, ordering: "alphabeticalReverse")
                ordering = "alphabeticalReverse"
              } label: {
                Text("Alphabetical A-Z")
                Image(systemName: "checkmark")
                  .foregroundColor(ordering == "alphabeticalReverse" ? .blue : .clear)
              }
              Button{
                user.changeFolderOrdering(folderName: folder.name, ordering: "alphabetical")
                ordering = "alphabetical"
              } label: {
                Text("Alphabetical Z-A")
                Image(systemName: "checkmark")
                  .foregroundColor(ordering == "alphabetical" ? .blue : .clear)
              }
            } label: {
              Text("Sort")
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
        }
    }
}

