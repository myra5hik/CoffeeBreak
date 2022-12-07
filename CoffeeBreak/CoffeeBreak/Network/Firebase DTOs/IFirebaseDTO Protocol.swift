//
//  IFirebaseDTO Protocol.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 07/12/22.
//

import Foundation

protocol IFirebaseDTO {
    init?(id: String, data: [String: Any])
    func toDict() -> (id: String, [String: Any])
}
