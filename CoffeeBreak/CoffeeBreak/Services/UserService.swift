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
    var currentUserPublisher: AnyPublisher<Person?, Never> { get }
    /// Pass nil to skip updating a field. Pass .some(nil) to surname to specificly null it.
    func updateUserInfo(name: String?, surname: String??, interests: [DiscussionTopic]?)
}

enum UserState {
    case authed(Person?)
    case nonauthed
    case error(Error)
}

// MARK: - UserService implementation

final class UserService<A: IAuthService, N: INetworkService>: ObservableObject {
    // State
    @Published private(set) var state: UserState = .nonauthed {
        didSet {
            if case .authed(let person) = state { _currentUserSubject.send(person); return }
            _currentUserSubject.send(nil)
        }
    }
    // Publishers
    private let _currentUserSubject = PassthroughSubject<Person?, Never>()
    var currentUserPublisher: AnyPublisher<Person?, Never> { _currentUserSubject.eraseToAnyPublisher() }
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

// MARK: - IUserService conformance

extension UserService: IUserService {
    var currentUser: Person? {
        if case .authed(let person) = state { return person }
        return nil
    }

    func updateUserInfo(name: String? = nil, surname: String?? = nil, interests: [DiscussionTopic]? = nil) {
        guard let currentUser = currentUser else { return }
        let new = Person(
            id: currentUser.id,
            name: name ?? currentUser.name,
            surname: surname ?? currentUser.surname,
            interests: interests ?? currentUser.interests
        )
        network.add(userInfo: new)
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
