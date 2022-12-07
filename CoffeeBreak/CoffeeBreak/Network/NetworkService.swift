//
//  NetworkService.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 07/12/22.
//

import Foundation

// MARK: - INetworkService protocol

protocol INetworkService: AnyObject {
    typealias Handler<T> = (Result<T, Error>) -> Void

    func loadUser(_ id: Person.ID, _ handler: Handler<Person>?)
}

// MARK: - Implementation

final class NetworkService<M: IFirebaseManager>: INetworkService {
    private let manager: M

    init(manager: M = FirebaseManager()) {
        self.manager = manager
    }

    func loadUser(_ id: Person.ID, _ handler: Handler<Person>?) {
        let request = UserRequest(userId: id)
        manager.loadDocument(request) { [weak self] (result) in
            self?.processResult(result, handler)
        }
    }
}

// MARK: - Generic helpers

private extension NetworkService {
    func processResult<T: IDomainModelRepresentable, DomainModel>(
        _ result: Result<T, Error>,
        _ handler: Handler<DomainModel>?
    ) where T.DomainModel == DomainModel {
        switch result {
        case .success(let fbValue):
            handler?(.success(fbValue.toDomainModel()))
        case .failure(let error):
            handler?(.failure(error))
        }
    }
}
