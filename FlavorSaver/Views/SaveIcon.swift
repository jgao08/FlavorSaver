//
//  SaveIcon.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation
import SwiftUI

struct SaveIcon: View {
    //  @Binding var RecipeInfo: Recipe_Info
    
    @State var saved: Bool = false
    @State var favorites: [String] = ["banana almond cake", "cheeseburger"]
    var recipeName = "cheeseburger"
    
    var body: some View  {
        Button {
            // Change the saved properties in the backend here
            print("Edit button was tapped")
            if favorites.contains(recipeName) {
                favorites.removeLast()
            } else {
                favorites.append(recipeName)
            }
        } label: {
            if favorites.contains(recipeName) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 24))
            } else {
                Image(systemName: "heart")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
            }
        }
    }
}

#Preview {
    SaveIcon()
}

