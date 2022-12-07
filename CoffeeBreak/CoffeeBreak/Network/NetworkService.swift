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
    typealias NetworkServiceSubscription = UUID

    func loadUserInfo(_ id: Person.ID, _ handler: Handler<Person>?)
    func subscribeToMeetupQueue(_ handler: Handler<[MeetupQueueElement]>?) -> NetworkServiceSubscription
    func unsubscribe(_ id: NetworkServiceSubscription)
}

// MARK: - Implementation

final class NetworkService<M: IFirebaseManager>: INetworkService {
    // Dependencies
    private let manager: M
    // State
    private var subscriptions = [NetworkServiceSubscription: M.ListenerID]()

    init(manager: M = FirebaseManager()) {
        self.manager = manager
    }

    func loadUserInfo(_ id: Person.ID, _ handler: Handler<Person>?) {
        let request = UserRequest(userId: id)
        manager.loadDocument(request) { [weak self] (result) in
            self?.processResult(result, handler)
        }
    }

    func subscribeToMeetupQueue(_ handler: Handler<[MeetupQueueElement]>?) -> NetworkServiceSubscription {
        let request = MeetupQueueRequest()
        let listenerId = manager.subscribeToCollection(request) { [weak self] (result) in
            self?.processResult(result, handler)
        }
        let id = UUID()
        subscriptions[id] = listenerId
        return id
    }

    func unsubscribe(_ id: NetworkServiceSubscription) {
        if let listenerId = subscriptions[id] {
            manager.cancel(id: listenerId)
            subscriptions[id] = nil
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

    func processResult<T: IDomainModelRepresentable, DomainModel>(
        _ result: Result<[T], Error>,
        _ handler: Handler<[DomainModel]>?
    ) where T.DomainModel == DomainModel {
        switch result {
        case .success(let fbValue):
            let parsed = fbValue.map({ $0.toDomainModel() })
            handler?(.success(parsed))
        case .failure(let error):
            handler?(.failure(error))
        }
    }
}
