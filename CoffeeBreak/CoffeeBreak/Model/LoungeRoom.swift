//
//  LoungeRoom.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 09.12.2022.
//

import Foundation

struct LoungeRoom: Identifiable, Hashable {
    let id: String
    let members: [Person.ID]
    let timeCreated: Date
    let timeExpires: Date
}
