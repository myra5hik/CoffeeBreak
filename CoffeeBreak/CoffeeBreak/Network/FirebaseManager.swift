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

    func loadCollection<R: IFirebaseCollectionRequest>(_ request: R, _ completion: Handler<[R.DTO]>?)
    func loadDocument<R: IFirebaseDocumentRequest>(_ request: R, _ completion: Handler<R.DTO>?)
    func subscribeToCollection<R: IFirebaseCollectionRequest>(_ request: R, onUpdate: Handler<[R.DTO]>?)
    func subscribeToDocument<R: IFirebaseDocumentRequest>(_ request: R, onUpdate: Handler<R.DTO>?)
}

// MARK: - FirebaseManager Implementation

final class FirebaseManager: IFirebaseManager {
    private let db = Firestore.firestore()

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

    func subscribeToCollection<R: IFirebaseCollectionRequest>(_ request: R, onUpdate: Handler<[R.DTO]>?) {
        db.collection(request.collection).addSnapshotListener { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: onUpdate)
        }
    }

    func subscribeToDocument<R: IFirebaseDocumentRequest>(_ request: R, onUpdate: Handler<R.DTO>?) {
        db.collection(request.collection).document(request.document).addSnapshotListener { [weak self] (snapshot, error) in
            self?.process(snapshot: snapshot, error: error, handler: onUpdate)
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
