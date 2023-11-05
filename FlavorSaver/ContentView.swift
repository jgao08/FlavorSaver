//
//  ContentView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var user: User

    var body: some View {
        SavedRecipesView().environmentObject(user)
    }
}
// Test for commit

#Preview {
    ContentView()
}
