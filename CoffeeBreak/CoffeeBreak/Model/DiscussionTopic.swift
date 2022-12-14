//
//  DiscussionTopic.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 08.12.2022.
//

import Foundation

enum DiscussionTopic: String, Identifiable, Hashable, CaseIterable {
    var id: String { self.rawValue }
    // Coding
    case coding
    case swift
    case swiftUi
    case uiKit
    // Design
    case design
    case uiDesign
    case uxDesign
    // Gaming
    case gaming
    case gameDevelopment
    // Sports
    case sports
    case football
    case skiing
    case hiking
    // Etc
    case food
}

extension DiscussionTopic {
    var title: String {
        switch self {
        case .swiftUi: return "SwiftUI"
        case .uiKit: return "UIKit"
        case .uiDesign: return "UI Design"
        case .uxDesign: return "UX Design"
        case .gameDevelopment: return "Game Development"
        default: return self.rawValue.uppercased()
        }
    }
    
    var allCases: [DiscussionTopic] {
        [
            Self.coding,
            Self.design,
            Self.food,
            Self.football,
            Self.gameDevelopment,
            Self.gaming,
            Self.hiking,
            Self.skiing,
            Self.sports,
            Self.swift,
            Self.swiftUi,
            Self.uiDesign,
            Self.uiKit
        ]
    }
}
