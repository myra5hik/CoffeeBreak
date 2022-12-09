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
}

// MARK: - IFirebaseDTO conformance

extension FBDTOPerson: IFirebaseDTO {
    private enum Keys: String {
        case name, surname, userId
    }

    init?(id: String, data: [String: Any]) {
        guard let name = data[Keys.name.rawValue] as? String else { return nil }
        self.init(id: id, name: name, surname: data[Keys.surname.rawValue] as? String)
    }

    func toDict() -> (id: String, [String : Any]) {
        var dict = [String: Any]()
        dict[Keys.name.rawValue] = self.name
        if let surname = self.surname { dict[Keys.surname.rawValue] = surname }
        return (id: self.id, dict)
    }
}

// MARK: - IDomainModelRepresentable conformance 

extension FBDTOPerson: IDomainModelRepresentable {
    init(domainModel: Person) {
        self.init(
            id: domainModel.id,
            name: domainModel.name,
            surname: domainModel.surname
        )
    }

    func toDomainModel() -> Person {
        return Person(
            id: id,
            name: name,
            surname: surname
        )
    }
}
