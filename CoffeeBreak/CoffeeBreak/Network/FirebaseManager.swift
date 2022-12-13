//
//  FirebaseManager.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 06/12/22.
//

import Foundation
import FirebaseFirestore

// MARK: - IFirebaseManager Protocol

protocol IFirebaseManager {
    typealias Handler<T> = (Result<T, Error>) -> Void
    typealias ListenerID = UUID
    // Create
    func addDocument<R: IFirebaseDocumentRequest>(_ data: R.DTO, _ request: R, _ completion: Handler<Void>?)
    // One-off read
    func loadCollection<R: IFirebaseCollectionRequest>(_ request: R, allowCached: Bool, _ completion: Handler<[R.DTO]>?)
    func loadDocument<R: IFirebaseDocumentRequest>(_ request: R, allowCached: Bool, _ completion: Handler<R.DTO>?)
    func removeDocument<R: IFirebaseDocumentRequest>(_ request: R, _ completion: Handler<Void>?)
    // Subscription read
    func subscribeToCollection<R: IFirebaseCollectionRequest>(_ request: R, allowCached: Bool, onUpdate: Handler<[R.DTO]>?) -> ListenerID
    func subscribeToDocument<R: IFirebaseDocumentRequest>(_ request: R, allowCached: Bool, onUpdate: Handler<R.DTO>?) -> ListenerID
    func cancel(id: ListenerID)
}

// MARK: - FirebaseManager Implementation

final class FirebaseManager {
    private lazy var db = Firestore.firestore()
    private var listeners = [ListenerID: ListenerRegistration]()
    
    deinit {
        for (_, listener) in listeners {
            listener.remove()
        }
    }
}

// MARK: - IFirebaseManager Conformance

extension FirebaseManager: IFirebaseManager {
    func addDocument<R: IFirebaseDocumentRequest>(_ data: R.DTO, _ request: R, _ completion: Handler<Void>?) {
        db.collection(request.collection).document(request.document).setData(data.toDict().1)
    }

    func loadCollection<R: IFirebaseCollectionRequest>(_ request: R, allowCached: Bool, _ completion: Handler<[R.DTO]>?) {
        let c = request.collection
        db.collection(c).getDocuments(source: allowCached ? .default : .server) { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: completion)
        }
    }

    func loadDocument<R: IFirebaseDocumentRequest>(_ request: R, allowCached: Bool, _ completion: Handler<R.DTO>?) {
        let (c, d) = (request.collection, request.document)
        db.collection(c).document(d).getDocument(source: allowCached ? .default : .server) { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: completion)
        }
    }

    func removeDocument<R: IFirebaseDocumentRequest>(_ request: R, _ completion: Handler<Void>?) {
        db.collection(request.collection).document(request.document).delete { error in
            if let error = error { completion?(.failure(error)); return }
            completion?(.success(()))
        }
    }

    func subscribeToCollection<R: IFirebaseCollectionRequest>(_ request: R, allowCached: Bool, onUpdate: Handler<[R.DTO]>?) -> ListenerID {
        let c = request.collection
        let mdOptIn = allowCached ? false : true
        let listener = db.collection(c).addSnapshotListener(includeMetadataChanges: mdOptIn) { [weak self] (snapshot, error) in
            if !allowCached && snapshot?.metadata.isFromCache ?? false { return }
            self?.process(snapshot: snapshot, error: error, handler: onUpdate)
        }
        let id = UUID()
        listeners[id] = listener
        return id
    }

    func subscribeToDocument<R: IFirebaseDocumentRequest>(_ request: R, allowCached: Bool, onUpdate: Handler<R.DTO>?) -> ListenerID {
        let (c, d) = (request.collection, request.document)
        let mdOptIn = allowCached ? false : true
        let listener = db.collection(c).document(d).addSnapshotListener(includeMetadataChanges: mdOptIn) { [weak self] (snapshot, error) in
            if !allowCached && snapshot?.metadata.isFromCache ?? false { return }
            self?.process(snapshot: snapshot, error: error, handler: onUpdate)
        }
        let id = UUID()
        listeners[id] = listener
        return id
    }

    func cancel(id: ListenerID) {
        if let listener = listeners[id] {
            listener.remove()
            listeners[id] = nil
        }
    }
}

// MARK: - Processing helpers

private extension FirebaseManager {
    private func process<DTO: IFirebaseDTO>(snapshot: QuerySnapshot?, error: Error?, handler: Handler<[DTO]>?) {
        if let error = error { handler?(.failure(error)); return }
        guard let snapshot = snapshot else { handler?(.failure(URLError(.badServerResponse))); return }
        // Parsing
        let parsed = snapshot.documents.compactMap { fbDocument in
            let id = fbDocument.documentID
            let data = fbDocument.data()
            let parsed = DTO(id: id, data: data)
            return parsed
        }
        guard parsed.count == snapshot.count else { handler?(.failure(URLError(.cannotParseResponse))); return }
        // Return
        handler?(.success(parsed))
    }

    private func process<DTO: IFirebaseDTO>(snapshot: DocumentSnapshot?, error: Error?, handler: Handler<DTO>?) {
        if let error = error { handler?(.failure(error)); return }
        guard
            let snapshot = snapshot,
            let data = snapshot.data(),
            let parsed = DTO(id: snapshot.documentID, data: data)
        else { handler?(.failure(URLError(.badServerResponse))); return }
        // Return
        handler?(.success(parsed))
    }
}
