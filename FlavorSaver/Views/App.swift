//
//  FlavorSaverApp.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct FlavorSaverApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authentication = Authentication()
    
    var body: some Scene {
        WindowGroup {
            if let user = authentication.currentUser {
                ContentView(user: user)
            } else {
                OnboardingView()
            }
        }
    }
}
