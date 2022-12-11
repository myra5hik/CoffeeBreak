//
//  MeetupQueueElement.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 07/12/22.
//

import Foundation

struct MeetupQueueElement: Identifiable {
    let id: String
    let timeCreated: Date
    let timeExpires: Date
    let topicIds: [String]
    let userId: Person.ID
}
