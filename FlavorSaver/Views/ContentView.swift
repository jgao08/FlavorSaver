//
//  ContentView.swift
//  FlavorSaver
//
//  Created by Jennifer Zhang on 12/3/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var user: User
  
  var body: some View {
    NavigationView {
      TabView {
        SearchView()
          .environmentObject(user)
          .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Search")
          }
        ProfileView()
          .environmentObject(user)
          .tabItem {
            Image(systemName: "person.fill")
            Text("Profile")
          }
        
      }
    }
    .preferredColorScheme(.light)
    .navigationViewStyle(StackNavigationViewStyle())    
  }
}

//#Preview {
//    ContentView()
//}
