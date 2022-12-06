//
//  CoffeeBreakApp.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 06/12/22.
//

import SwiftUI
import FirebaseCore

@main
struct CoffeeBreakApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - UIKit AppDelegate, required for Firebase

fileprivate class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
