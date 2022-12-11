//
//  DiscussionTopic.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 08.12.2022.
//

import Foundation

enum DiscussionTopic: String, Identifiable, Hashable, CaseIterable {
    var id: String { self.rawValue }
    
    case coding
    case food
    case design
}

extension DiscussionTopic {
    var title: String { self.rawValue.uppercased() }
}
