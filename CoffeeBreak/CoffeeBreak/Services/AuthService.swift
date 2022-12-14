//
//  AuthService.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 12/12/22.
//

import Foundation
import FirebaseCore
import FirebaseAuth

// MARK: - IAuthService protocol

protocol IAuthService: AnyObject, ObservableObject {
    var currentAuth: Person.ID? { get }
    var currentAuthPublisher: Published<Person.ID?>.Publisher { get }
    func authAnonymously()
}

// MARK: - AuthService implementation

final class AuthService: ObservableObject, IAuthService {
    @Published private(set) var currentAuth: Person.ID?
    var currentAuthPublisher: Published<Person.ID?>.Publisher { $currentAuth }

    func authAnonymously() {
        guard currentAuth == nil else { return }
        Auth.auth().signInAnonymously { [weak self] (result, error) in
            guard error == nil, let id = result?.user.uid else { return }
            self?.currentAuth = id
        }
    }
}
