//
//  ScreenFactory.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 14/12/22.
//

import SwiftUI

// MARK: - IScreenFactory protocol

protocol IScreenFactory: AnyObject {
    func makeMainScreen() -> AnyView
    func makeMeetView() -> AnyView
    func makeMeetActiveView(matchId: Person.ID?) -> AnyView
    func makeProfileView() -> AnyView
    func makeHistoryView() -> AnyView
}

// MARK: - Implementation

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
        AnyView(MeetView(matchService: services.match, factory: self))
    }

    func makeMeetActiveView(matchId: Person.ID?) -> AnyView {
        AnyView(MeetActiveView(matchId: matchId))
    }

    func makeProfileView() -> AnyView {
        AnyView(ProfileView(userService: services.user))
    }

    func makeHistoryView() -> AnyView {
        AnyView(HistoryView())
    }
}

// MARK: - Stub Implementation

final class StubScreenFactory: IScreenFactory {
    func makeMainScreen() -> AnyView { AnyView(Text("Main Screen")) }
    func makeMeetView() -> AnyView { AnyView(Text("Main Screen")) }
    func makeMeetActiveView(matchId: Person.ID?) -> AnyView { AnyView(Text("Main Screen")) }
    func makeProfileView() -> AnyView { AnyView(Text("Main Screen")) }
    func makeHistoryView() -> AnyView { AnyView(Text("Main Screen")) }
}
