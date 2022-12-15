//
//  ServicesModule.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 14/12/22.
//

import Foundation

// MARK: - IServicesModule protocol

protocol IServicesModule: AnyObject {
    associatedtype MS: IMatchService
    associatedtype NS: INetworkService
    associatedtype US: IUserService
    associatedtype AS: IAuthService

    var match: MS { get }
    var network: NS { get }
    var user: US { get }
    var auth: AS { get }
}

// MARK: - Implementation

final class ServicesModule: IServicesModule {
    typealias AS = AuthService
    typealias NS = NetworkService<FirebaseManager>
    typealias US = UserService<AS, NS>
    typealias MS = MatchService<NS, US>

    let match: MS
    let network: NS
    let user: US
    let auth: AS

    init() {
        // Init
        let auth = AuthService()
        let fbManager = FirebaseManager()
        let network = NetworkService(manager: fbManager)
        let user = UserService(authService: auth, networkService: network)
        let match = MatchService(networkService: network, userService: user)
        // Assignment
        self.match = match
        self.network = network
        self.user = user
        self.auth = auth
    }
}
