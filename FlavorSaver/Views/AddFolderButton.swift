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
    @Binding var folders: [Folder]

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
                print("Save button clicked", folderName) // Moved print statement here
                if createFolder() && recipe != nil {
                    user.addRecipeToFolder(recipe: recipe!, folderName: folderName)
                    isNamingFolder = false
                    print("Folder created", folderName)
                    folderName = "" // Reset folderName after successful folder creation
                } else if recipe == nil{
                    print("Folder created but recipe not added")
                } else {
                    // Optionally handle the case when createFolder() returns false
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
        folders = user.getSavedRecipeFolders()
        return folderCreated
    }
    
    func toggleNamingFolder() {
        isNamingFolder.toggle()
    }
}
