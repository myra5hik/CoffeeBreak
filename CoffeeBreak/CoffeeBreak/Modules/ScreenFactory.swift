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

final class ScreenFactory<Services: IServicesModule>: IScreenFactory {
    // Private
    private let services: Services

    init(services: Services) {
        self.services = services
    }

    func makeMainScreen() -> AnyView {
        AnyView(ContentView(factory: self))
    }

    func makeMeetView() -> AnyView {
        AnyView(MeetView(matchService: services.match, factory: self))
    }

    func makeMeetActiveView(matchId: Person.ID?) -> AnyView {
        let vm = MeetActiveView<Services.NS>.ViewModel(service: services.network, matchId: matchId)
        return AnyView(MeetActiveView<Services.NS>(vm: vm))
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
