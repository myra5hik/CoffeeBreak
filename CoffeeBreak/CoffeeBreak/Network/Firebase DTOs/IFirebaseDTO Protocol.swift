//
//  IFirebaseDTO Protocol.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 07/12/22.
//

import Foundation

protocol IFirebaseDTO {
    // Raw Firebase types
    init?(id: String, data: [String: Any])
    func toDict() -> (id: String, [String: Any])
}

protocol IDomainModelRepresentable {
    associatedtype DomainModel
    // Domain models
    init(domainModel: DomainModel)
    func toDomainModel() -> DomainModel
}
