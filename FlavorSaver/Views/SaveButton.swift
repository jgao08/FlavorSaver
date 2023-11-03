//
//  SaveButton.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation
import SwiftUI

struct SaveButton: View {
    //  @Binding var RecipeInfo: Recipe_Info
    
    @State var saved: Bool = false
    @State var favorites: [String] = ["banana almond cake", "cheeseburger"]
    var recipeName = "cheeseburger"
    
    var body: some View  {
        Button(action: {
            if favorites.contains(recipeName) {
                favorites.removeLast()
            } else {
                favorites.append(recipeName)
            }
        }, label: {
            if favorites.contains(recipeName) {
                Image(systemName: "heart.fill")
                Text("Recipe Saved")
            } else {
                Image(systemName: "heart")
                Text("Save Recipe")
            }
        })
        .tint(favorites.contains(recipeName) ? .orange : .white)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .foregroundStyle(Color.black)
        .shadow(radius: 10)
    }
}

#Preview {
    SaveButton()
}
