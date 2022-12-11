//
//  FBDTOLoungeRoom.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 09.12.2022.
//

import Foundation
import FirebaseFirestore

struct FBDTOLoungeRoom: Identifiable, Hashable {
    let id: String
    let members: [Person.ID]
    let timeCreated: Date
    let timeExpires: Date
}

// MARK: - IFirebaseDTO conformance

extension FBDTOLoungeRoom: IFirebaseDTO {
    private enum Keys: String {
        case users, timeExpires, timeCreated
    }
    
    init?(id: String, data: [String: Any]) {
        guard
            let members = data[Keys.users.rawValue] as? [Person.ID],
            let timeCreated = (data[Keys.timeCreated.rawValue] as? Timestamp)?.dateValue(),
            let timeExpires = (data[Keys.timeExpires.rawValue] as? Timestamp)?.dateValue()
        else { return nil }

        self.init(
            id: id,
            members: members,
            timeCreated: timeCreated,
            timeExpires: timeExpires
        )
    }
    
    func toDict() -> (id: String, [String : Any]) {
        let data: [String: Any] = [
            Keys.users.rawValue: self.members,
            Keys.timeCreated.rawValue: Timestamp(date: self.timeCreated),
            Keys.timeExpires.rawValue: Timestamp(date: self.timeExpires)
        ]
        return (id: id, data)
    }
}

// MARK: - IDomainModelRepresentable conformance

extension FBDTOLoungeRoom: IDomainModelRepresentable {
    init(domainModel: LoungeRoom) {
        self.init(
            id: domainModel.id,
            members: domainModel.members,
            timeCreated: domainModel.timeCreated,
            timeExpires: domainModel.timeExpires
        )
    }
    
    func toDomainModel() -> LoungeRoom {
        return LoungeRoom(
            id: self.id,
            members: self.members,
            timeCreated: self.timeCreated,
            timeExpires: self.timeExpires
        )
    }
}
