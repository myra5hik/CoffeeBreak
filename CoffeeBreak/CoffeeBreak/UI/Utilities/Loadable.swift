//
//  Loadable.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 15/12/22.
//

import Foundation

enum Loadable<T, E: Error> {
    case loaded(T)
    case loading
    case error(E)
    
    ///
    /// Provides loaded of type T, or default values specified in arguments
    ///
    func flatten(loadingState: T, errorState: T) -> T {
        switch self {
        case .loaded(let loaded): return loaded
        case .loading: return loadingState
        case .error: return errorState
        }
    }
}
