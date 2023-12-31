//
//  SaveIcon.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation
import SwiftUI

struct SaveIcon: View {
    @EnvironmentObject var user: User
    var recipe: Recipe
    @State var colorMode: Bool = true // if true: white, else: black
    @State private var folderSelect = false
    @State private var isSaved: Bool = false
    
    var body: some View  {
        Group {
            Button {
                folderSelect = true
            } label: {
                if isSaved {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                } else {
                    Image(systemName: "heart")
                        .foregroundColor(colorMode ? .white : .black)
                        .font(.system(size: 24))
                }
            }
        }
        .sheet(isPresented: $folderSelect, content: {
            FolderSelectView(recipe: recipe).environmentObject(user)
        })
        .onChange(of: folderSelect) {
            isSaved = user.isRecipeSaved(recipeID: recipe.id)
        }
        .onAppear() {
            isSaved = user.isRecipeSaved(recipeID: recipe.id)
        }
    }
}

