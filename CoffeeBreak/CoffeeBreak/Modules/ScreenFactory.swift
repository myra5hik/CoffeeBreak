//
//  ScreenFactory.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 14/12/22.
//

import SwiftUI

protocol IScreenFactory: AnyObject {
    func makeMainScreen() -> AnyView
    func makeMeetView() -> AnyView
    func makeProfileView() -> AnyView
    func makeHistoryView() -> AnyView
}

final class ScreenFactory<SM: IServicesModule>: IScreenFactory {
    // Private
    private let services: SM

    init(services: SM) {
        self.services = services
    }

    func makeMainScreen() -> AnyView {
        AnyView(ContentView(factory: self))
    }

    func makeMeetView() -> AnyView {
        AnyView(MeetView(matchService: services.match))
    }

    func makeProfileView() -> AnyView {
        AnyView(ProfileView(userService: services.user))
    }

    func makeHistoryView() -> AnyView {
        AnyView(HistoryView())
    }
}
