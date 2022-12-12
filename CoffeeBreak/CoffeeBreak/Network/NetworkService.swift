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
    // Create, update
    func add(loungeRoom: LoungeRoom)
    func add(meetupQueueElement: MeetupQueueElement)
    func add(userInfo: Person)
    // Read
    func loadUserInfo(_ id: Person.ID, _ handler: Handler<Person>?)
    func subscribeToUserInfo(_ id: Person.ID, _ handler: Handler<Person>?) -> NetworkServiceSubscription
    func subscribeToMeetupQueue(_ handler: Handler<[MeetupQueueElement]>?) -> NetworkServiceSubscription
    func subscribeToLoungeRooms(_ handler: Handler<[LoungeRoom]>?) -> NetworkServiceSubscription
    // Delete
    func removeMeetupQueueElement(_ id: MeetupQueueElement.ID)
    func removeLoungeRoom(_ id: LoungeRoom.ID)
    // Stop following
    func unsubscribe(_ id: NetworkServiceSubscription)
}

// MARK: - Implementation

final class NetworkService<M: IFirebaseManager> {
    // Dependencies
    private lazy var manager: M! = nil
    // State
    private var subscriptions = [NetworkServiceSubscription: M.ListenerID]()

    init(manager: M) {
        self.manager = manager
    }
    
    deinit {
        for (_, listener) in subscriptions {
            manager.cancel(id: listener)
        }
    }
}

// MARK: - INetworkService Conformance

extension NetworkService: INetworkService {

    // MARK: Create, update

    func add(loungeRoom: LoungeRoom) {
        let request = LoungeRoomRequest(loungeRoomId: loungeRoom.id)
        let dto = FBDTOLoungeRoom(domainModel: loungeRoom)
        manager.addDocument(dto, request, nil)
    }

    func add(meetupQueueElement: MeetupQueueElement) {
        let request = MeetupQueueElementRequest(elementId: meetupQueueElement.id)
        let dto = FBDTOMeetupQueueElement(domainModel: meetupQueueElement)
        manager.addDocument(dto, request, nil)
    }

    func add(userInfo: Person) {
        let request = UserRequest(userId: userInfo.id)
        let dto = FBDTOPerson(domainModel: userInfo)
        manager.addDocument(dto, request, nil)
    }

    // MARK: Read

    func loadUserInfo(_ id: Person.ID, _ handler: Handler<Person>?) {
        let request = UserRequest(userId: id)
        manager.loadDocument(request, allowCached: true) { [weak self] (result) in
            self?.processResult(result, handler)
        }
    }

    func subscribeToUserInfo(_ id: Person.ID, _ handler: Handler<Person>?) -> NetworkServiceSubscription {
        let request = UserRequest(userId: id)
        let listenerId = manager.subscribeToDocument(request, allowCached: true) { [weak self] result in
            self?.processResult(result, handler)
        }
        return registerListener(listenerId)
    }

    func subscribeToMeetupQueue(_ handler: Handler<[MeetupQueueElement]>?) -> NetworkServiceSubscription {
        let request = MeetupQueueRequest()
        let listenerId = manager.subscribeToCollection(request, allowCached: false) { [weak self] (result) in
            self?.processResult(result, handler)
        }
        return registerListener(listenerId)
    }

    func subscribeToLoungeRooms(_ handler: Handler<[LoungeRoom]>?) -> NetworkServiceSubscription {
        let request = LoungeRoomsRequest()
        let listenerId = manager.subscribeToCollection(request, allowCached: true) { [weak self] (result) in
            self?.processResult(result, handler)
        }
        return registerListener(listenerId)
    }

    // MARK: Delete

    func removeMeetupQueueElement(_ id: MeetupQueueElement.ID) {
        let request = MeetupQueueElementRequest(elementId: id)
        manager.removeDocument(request, nil)
    }

    func removeLoungeRoom(_ id: LoungeRoom.ID) {
        let request = LoungeRoomRequest(loungeRoomId: id)
        manager.removeDocument(request, nil)
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

    func registerListener(_ listenerId: IFirebaseManager.ListenerID) -> NetworkServiceSubscription {
        let internalId = UUID()
        subscriptions[internalId] = listenerId
        return internalId
    }
}
