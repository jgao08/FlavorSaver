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

    var folder: Folder
    @Binding var isShowingFolder: Bool
    
    @State private var showingEditFolder: Bool = false
    
    private let columns = [
        //        GridItem(.flexible(), spacing: 16),
        //        GridItem(.flexible(), spacing: 16)
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
        .navigationBarItems(trailing:
        Button {
            showingEditFolder = true
        } label: {
            Image(systemName: "ellipsis")
        })
        .confirmationDialog("Folder Settings", isPresented: $showingEditFolder) {
            Button("Delete Folder", role: .destructive) {
                user.deleteFolder(folderName: folder.name)
                isShowingFolder = false
            }
            .foregroundColor(.red)
        }
        
    }
}

