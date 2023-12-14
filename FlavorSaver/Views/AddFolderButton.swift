//
//  AddFolderButton.swift
//  FlavorSaver
//
//  Created by Erica Fu on 12/3/23.
//

import Foundation
import SwiftUI

struct AddFolderButton: View {
    @EnvironmentObject var user: User
    
    @State private var isNamingFolder: Bool = false
    @State private var folderName: String = ""
    var recipe: Recipe?
    
    var body: some View  {
        Button {
            isNamingFolder.toggle()
        } label: {
            Image(systemName: "plus")
        }
        .alert("New Folder", isPresented: $isNamingFolder) {
            TextField("Name", text: $folderName)
                .textInputAutocapitalization(.never)
            
            Button("Save") {
                if user.createFolder(name: folderName) && recipe != nil {
                    user.addRecipeToFolder(recipe: recipe!, folderName: folderName)
                    isNamingFolder = false
                    folderName = ""
                }
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Enter a name for this folder")
        }
    }
}
