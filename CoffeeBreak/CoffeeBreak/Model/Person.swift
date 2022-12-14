//
//  Person.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 07/12/22.
//

import Foundation

struct Person: Identifiable, Hashable {
    let id: String
    let name: String
    let surname: String?
    let interests: [DiscussionTopic]
    
    static var dummy: Person {
        Person(
            id: "dummy-test",
            name: "Dummy",
            surname: "User",
            interests: [.coding, .food]
        )
    }
}
