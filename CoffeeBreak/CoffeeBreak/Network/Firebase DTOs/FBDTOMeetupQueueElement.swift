//
//  MeetupQueueElement.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 07/12/22.
//

import Foundation
import FirebaseFirestore

struct FBDTOMeetupQueueElement: Identifiable, Hashable {
    let id: String
    let timeExpires: Date
    let topicIds: [String]
    let userId: String
}

// MARK: - IFirebaseDTO conformance

extension FBDTOMeetupQueueElement: IFirebaseDTO {
    private enum Keys: String {
        case timeExpires, topicIds, userId
    }

    init?(id: String, data: [String: Any]) {
        guard
            let timeExpires = (data[Keys.timeExpires.rawValue] as? Timestamp)?.dateValue(),
            let topicIds = data[Keys.topicIds.rawValue] as? [String],
            let userId = data[Keys.userId.rawValue] as? String
        else { return nil }

        self.init(id: id, timeExpires: timeExpires, topicIds: topicIds, userId: userId)
    }

    func toDict() -> (id: String, [String : Any]) {
        return (
            id: self.id,
            [
                Keys.timeExpires.rawValue: Timestamp(date: self.timeExpires),
                Keys.topicIds.rawValue: self.topicIds,
                Keys.userId.rawValue: self.userId
            ]
        )
    }
}

// MARK: - IDomainModelRepresentable conformance

extension FBDTOMeetupQueueElement: IDomainModelRepresentable {
    init(domainModel: MeetupQueueElement) {
        self.init(
            id: domainModel.id,
            timeExpires: domainModel.timeExpires,
            topicIds: domainModel.topicIds,
            userId: domainModel.userId
        )
    }

    func toDomainModel() -> MeetupQueueElement {
        return MeetupQueueElement(
            id: self.id,
            timeExpires: self.timeExpires,
            topicIds: self.topicIds,
            userId: self.userId
        )
    }
}