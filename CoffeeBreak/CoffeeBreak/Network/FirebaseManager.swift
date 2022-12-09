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
    // One-off
    func loadCollection<R: IFirebaseCollectionRequest>(_ request: R, _ completion: Handler<[R.DTO]>?)
    func loadDocument<R: IFirebaseDocumentRequest>(_ request: R, _ completion: Handler<R.DTO>?)
    // Subscriptions
    func subscribeToCollection<R: IFirebaseCollectionRequest>(_ request: R, onUpdate: Handler<[R.DTO]>?) -> ListenerID
    func subscribeToDocument<R: IFirebaseDocumentRequest>(_ request: R, onUpdate: Handler<R.DTO>?) -> ListenerID
    func cancel(id: ListenerID)
}

// MARK: - FirebaseManager Implementation

final class FirebaseManager: IFirebaseManager {
    private let db = Firestore.firestore()
    private var listeners = [ListenerID: ListenerRegistration]()

    func loadCollection<R: IFirebaseCollectionRequest>(_ request: R, _ completion: Handler<[R.DTO]>?) {
        db.collection(request.collection).getDocuments { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: completion)
        }
    }

    func loadDocument<R: IFirebaseDocumentRequest>(_ request: R, _ completion: Handler<R.DTO>?) {
        db.collection(request.collection).document(request.document).getDocument { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: completion)
        }
    }

    func subscribeToCollection<R: IFirebaseCollectionRequest>(_ request: R, onUpdate: Handler<[R.DTO]>?) -> ListenerID {
        let listener = db.collection(request.collection).addSnapshotListener { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: onUpdate)
        }
        let id = UUID()
        listeners[id] = listener
        return id
    }

    func subscribeToDocument<R: IFirebaseDocumentRequest>(_ request: R, onUpdate: Handler<R.DTO>?) -> ListenerID {
        let (col, doc) = (request.collection, request.document)
        let listener = db.collection(col).document(doc).addSnapshotListener { [weak self] (snapshot, error) in
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
