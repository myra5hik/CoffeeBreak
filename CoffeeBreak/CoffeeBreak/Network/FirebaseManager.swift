//
//  FirebaseManager.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 06/12/22.
//

import Foundation
import Firebase

// MARK: - IFirebaseManager Protocol

protocol IFirebaseManager {
    typealias Handler<T> = (Result<T, Error>) -> Void

    // Keyed
    func loadAllDocuments(collection: FBCollectionKey, _ completion: Handler<[[String: Any]]>?)
    func loadDocument(collection: FBCollectionKey, document: String, _ completion: Handler<[String: Any]>?)
    func subscribeToCollection(collection: FBCollectionKey, onUpdate: Handler<[[String: Any]]>?)
    func subscribeToDocument(collection: FBCollectionKey, doc: String, onUpdate: Handler<[String: Any]>?)
    // Raw
    func loadAllDocuments(collection: String, _ completion: Handler<[[String: Any]]>?)
    func loadDocument(collection: String, document: String, _ completion: Handler<[String: Any]>?)
    func subscribeToCollection(collection: String, onUpdate handler: Handler<[[String: Any]]>?)
    func subscribeToDocument(collection: String, doc: String, onUpdate handler: Handler<[String: Any]>?)
}

extension IFirebaseManager {
    func loadAllDocuments(collection: FBCollectionKey, _ completion: Handler<[[String: Any]]>?) {
        loadAllDocuments(collection: collection.rawValue, completion)
    }

    func loadDocument(collection: FBCollectionKey, document: String, _ completion: Handler<[String: Any]>?) {
        loadDocument(collection: collection.rawValue, document: document, completion)
    }

    func subscribeToCollection(collection: FBCollectionKey, onUpdate: Handler<[[String: Any]]>?) {
        subscribeToCollection(collection: collection.rawValue, onUpdate: onUpdate)
    }

    func subscribeToDocument(collection: FBCollectionKey, doc: String, onUpdate: Handler<[String: Any]>?) {
        subscribeToDocument(collection: collection.rawValue, doc: doc, onUpdate: onUpdate)
    }
}

// MARK: - Firebase Collection Keys

enum FBCollectionKey: String, Hashable {
    case meetupQueue = "meetup-queue"
}

// MARK: - FirebaseManager Implementation

final class FirebaseManager: IFirebaseManager {
    private let db = Firestore.firestore()

    func loadAllDocuments(collection: String, _ completion: Handler<[[String: Any]]>?) {
        db.collection(collection).getDocuments() { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: completion)
        }
    }

    func loadDocument(collection: String, document: String, _ completion: Handler<[String: Any]>?) {
        db.collection(collection).document(document).getDocument { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: completion)
        }
    }

    func subscribeToCollection(collection: String, onUpdate handler: Handler<[[String: Any]]>?) {
        db.collection(collection).addSnapshotListener { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: handler)
        }
    }

    func subscribeToDocument(collection: String, doc: String, onUpdate handler: Handler<[String: Any]>?) {
        db.collection(collection).document(doc).addSnapshotListener { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: handler)
        }
    }
}

// MARK: - Processing helpers

private extension FirebaseManager {
    private func process(snapshot: QuerySnapshot?, error: Error?, handler: Handler<[[String: Any]]>?) {
        if let error = error { handler?(.failure(error)); return }
        guard let snapshot = snapshot else { handler?(.failure(URLError(.badServerResponse))); return }
        handler?(.success(snapshot.documents.map({ $0.data() })))
    }

    private func process(snapshot: DocumentSnapshot?, error: Error?, handler: Handler<[String: Any]>?) {
        if let error = error { handler?(.failure(error)); return }
        guard
            let snapshot = snapshot,
            let data = snapshot.data()
        else { handler?(.failure(URLError(.badServerResponse))); return }
        handler?(.success(data))
    }
}
