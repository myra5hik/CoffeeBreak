//
//  CoffeeBreakApp.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 06/12/22.
//

import SwiftUI
import FirebaseCore

let manager = FirebaseManager()
let network = NetworkService(manager: manager)
let auth = AuthService()
let user = UserService(authService: auth, networkService: network)
let match = MatchService(networkService: network, userService: user)

@main
struct CoffeeBreakApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate

    private let matchService: MatchService<NetworkService<FirebaseManager>, UserService<AuthService, NetworkService<FirebaseManager>>>
    private let networkService: NetworkService<FirebaseManager>
    private let userService: UserService<AuthService, NetworkService<FirebaseManager>>
    private let authService: AuthService

    init() {
        // Initialization
    
        // Assignments
        self.networkService = network
        self.authService = auth
        self.userService = user
        self.matchService = match
        // Auth -- in async block to trigger Firebase after App didFinishLaunching call
        DispatchQueue.main.async { [weak authService] in
            authService?.authAnonymously()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(matchService: matchService)
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
