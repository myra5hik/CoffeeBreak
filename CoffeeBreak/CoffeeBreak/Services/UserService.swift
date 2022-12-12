//
//  UserService.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 12/12/22.
//

import Foundation
import Combine

// MARK: - IUserService protocol

protocol IUserService: ObservableObject {
    var state: UserState { get }
    var currentUser: Person? { get }
}

enum UserState {
    case authed(Person?)
    case nonauthed
    case error(Error)
}

// MARK: - UserService implementation

final class UserService<A: IAuthService, N: INetworkService>: ObservableObject, IUserService {
    // State
    @Published private(set) var state: UserState = .nonauthed
    var currentUser: Person? {
        if case .authed(let person) = state { return person }
        return nil
    }
    // Dependencies
    private let auth: A
    private let network: N
    // Etc
    private var userInfoSubscription: NetworkService.NetworkServiceSubscription?
    private var bag = Set<AnyCancellable>()

    init(authService: A, networkService: N) {
        self.auth = authService
        self.network = networkService
        subscribeToAuth()
    }

    deinit {
        if let subscription = userInfoSubscription {
            network.unsubscribe(subscription)
        }
    }
}

// MARK: - Private helpers

private extension UserService {
    func subscribeToAuth() {
        auth.currentAuth.sink { [weak self] personId in
            if let id = personId { self?.subscribeToUserUpdates(id) }
        }
        .store(in: &bag)
    }

    func subscribeToUserUpdates(_ id: Person.ID) {
        if let subscription = userInfoSubscription { network.unsubscribe(subscription) }
        userInfoSubscription = network.subscribeToUserInfo(id) { [weak self] (result) in
            if case .success(let person) = result {
                self?.state = .authed(person)
            } else {
                self?.state = .authed(nil)
            }
        }
    }
}
