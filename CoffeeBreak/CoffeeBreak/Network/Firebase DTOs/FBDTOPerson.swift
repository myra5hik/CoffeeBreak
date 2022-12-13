//
//  FBDTOPerson.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 07/12/22.
//

import Foundation

struct FBDTOPerson: Identifiable, Hashable {
    let id: String
    let name: String
    let surname: String?
    let interests: [String]
}

// MARK: - IFirebaseDTO conformance

extension FBDTOPerson: IFirebaseDTO {
    private enum Keys: String {
        case name, surname, interests
    }

    init?(id: String, data: [String: Any]) {
        guard
            let name = data[Keys.name.rawValue] as? String,
            let interests = data[Keys.interests.rawValue] as? [String]
        else { return nil }

        self.init(
            id: id,
            name: name,
            surname: data[Keys.surname.rawValue] as? String,
            interests: interests
        )
    }

    func toDict() -> (id: String, [String : Any]) {
        let dict: [String: Any] = [
            Keys.name.rawValue: self.name,
            Keys.surname.rawValue: self.surname as Any,
            Keys.interests.rawValue: self.interests
        ]

        return (id: self.id, dict)
    }
}

// MARK: - IDomainModelRepresentable conformance 

extension FBDTOPerson: IDomainModelRepresentable {
    init(domainModel: Person) {
        self.init(
            id: domainModel.id,
            name: domainModel.name,
            surname: domainModel.surname,
            interests: domainModel.interests.map { $0.rawValue }
        )
    }

    func toDomainModel() -> Person {
        return Person(
            id: id,
            name: name,
            surname: surname,
            interests: interests.compactMap { DiscussionTopic(rawValue: $0) }
        )
    }
}
