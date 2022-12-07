//
//  FirebaseRequests.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 07/12/22.
//

import Foundation

// MARK: - Firebase Request Protocols

protocol IFirebaseCollectionRequest {
    associatedtype DTO: IFirebaseDTO
    var collection: String { get }
}

protocol IFirebaseDocumentRequest {
    associatedtype DTO: IFirebaseDTO
    var collection: String { get }
    var document: String { get }
}

// MARK: - Request Implementations

struct MeetupQueueRequest: IFirebaseCollectionRequest {
    typealias DTO = FBDTOMeetupQueueElement
    let collection = FirebaseCollectionKey.meetupQueue.rawValue
}

// MARK: - Firebase Collection Keys

enum FirebaseCollectionKey: String, Hashable {
    case meetupQueue = "meetup-queue"
}
