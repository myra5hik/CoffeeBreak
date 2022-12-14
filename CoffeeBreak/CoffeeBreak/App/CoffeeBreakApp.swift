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
    private let screens: any IScreenFactory

    init() {
        let services = ServicesModule()
        self.screens = ScreenFactory(services: services)
        // Initialization
    
        // Assignments
        self.networkService = network
        self.authService = auth
        self.userService = user
        self.matchService = match
        // Auth -- in async block to trigger Firebase after App didFinishLaunching call
        DispatchQueue.main.async { [weak services] in
            services?.auth.authAnonymously()
        }
    }

    var body: some Scene {
        WindowGroup {
            screens.makeMainScreen()
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
