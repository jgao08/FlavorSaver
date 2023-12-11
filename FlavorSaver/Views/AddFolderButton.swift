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
            toggleNamingFolder()
        } label: {
            Image(systemName: "plus")
        }
        .alert("New Folder", isPresented: $isNamingFolder) {
            TextField("Name", text: $folderName)
                .textInputAutocapitalization(.never)
            
            Button("Save") {
                print("Save button clicked", folderName)
                if createFolder() && recipe != nil {
                    user.addRecipeToFolder(recipe: recipe!, folderName: folderName)
                    isNamingFolder = false
                    print("Folder created", folderName)
                    folderName = ""
                } else if recipe == nil{
                    print("Folder created but recipe not added")
                } else {
                    print("Folder creation failed")
                }
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Enter a name for this folder")
        }
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
