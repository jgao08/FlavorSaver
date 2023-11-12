//
//  FlavorSaverApp.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct FlavorSaverApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var user: User = User(userID: 0)
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView {
                    SearchView()
                        .environmentObject(user)
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    SavedRecipesView()
                        .environmentObject(user)
                        .tabItem {
                            Image(systemName: "heart")
                            Text("Saved")
                        }

                }
            }
            .preferredColorScheme(.light)
        }
    }
}
