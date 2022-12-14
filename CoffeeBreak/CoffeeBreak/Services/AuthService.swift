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
    var currentAuth: Published<Person.ID?>.Publisher { get }
    func authAnonymously()
}

// MARK: - AuthService implementation

final class AuthService: ObservableObject, IAuthService {
    @Published private var _currentAuth: Person.ID?
    var currentAuth: Published<Person.ID?>.Publisher { $_currentAuth }

    func authAnonymously() {
        guard _currentAuth == nil else { return }
        Auth.auth().signInAnonymously { [weak self] (result, error) in
            guard error == nil, let id = result?.user.uid else { return }
            self?._currentAuth = id
            print(id)
        }
    }
}
