//
//  MeetView.swift
//  testingAgainNC2
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct MeetView<M: IMatchService>: View {
    // Dependencies
    @ObservedObject private var service: M
    let factory: any IScreenFactory
    let haptics = HapticFeedback()
    // State
    private var matchedPerson: Person.ID? {
        if case .match(with: let id) = service.matchState { return id }
        return nil
    }
    @State private var showingMatchScreenOverlay = false
    @State private var showingCancelSearchAlert: Bool = false

    init(matchService: M, factory: any IScreenFactory) {
        self.service = matchService
        self.factory = factory
    }

    var body: some View {
        VStack {
            header
            Spacer()
            searchButton
            Spacer()
            Spacer()
        }
        .overlay { cancellationButton.offset(y: 250) }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CoffeeColors.meetViewBackground)
        .fullScreenCover(isPresented: $showingMatchScreenOverlay) {
            factory.makeMeetActiveView(matchId: matchedPerson)
        }
        .onChange(of: service.matchState) { state in
            if case .match = state { showingMatchScreenOverlay = true; return }
            showingMatchScreenOverlay = false
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Spacer().frame(height: 60.0)
            Text("Coffee Break")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Find others who are taking a break \nand connect.")
                .font(.subheadline)
                .foregroundColor(CoffeeColors.subText)

        }
    }

    @ViewBuilder
    private var searchButton: some View {
        switch service.matchState {
        case .uninitiated:
            Text("Loading: State Uninitiated").foregroundColor(.white)
        case .idle:
            MeetButton(text: "Take a Break", buttonClickable: true, state: .idle) {
                service.requestCoffeeBreak()
                haptics.bigButton.impactOccurred()
            }
        case .searching:
            MeetButton(text: "Searching...", buttonClickable: false, state: .searching)
        case .match:
            EmptyView()
        case .error(let error):
            Text(error.localizedDescription)
        }
    }

    @ViewBuilder
    private var cancellationButton: some View {
        let actionSheetButton = Button(
            "End Search",
            role: .destructive,
            action: { service.cancelCoffeeBreakRequest() }
        )

        if (service.matchState == .searching) {
            Button(action: {
                showingCancelSearchAlert = true
            }, label: {
                Text("Cancel Search").bold().foregroundColor(Color ( "Stroke"))
            })
            .confirmationDialog(
                "End Search",
                isPresented: $showingCancelSearchAlert,
                actions: { actionSheetButton }
            )
        }
    }
}

// MARK: - Previews

struct MeetView_Previews: PreviewProvider {
    static var previews: some View {
        MeetView(matchService: StubMatchService(state: .idle), factory: StubScreenFactory())
    }
}
