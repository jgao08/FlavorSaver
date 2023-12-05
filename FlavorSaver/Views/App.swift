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
  
    @StateObject var user: User = User(userID: "r3A1ofwrC6cA1OtgWNQYYU2bLaH21", username: "Racacoonie", profileID: 1)
//  var accountManager = AccountManager()
  
  var body: some Scene {
    WindowGroup{
        ContentView(user: user)

    }
  }
}
