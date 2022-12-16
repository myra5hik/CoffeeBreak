//
//  MeetActiveView.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct MeetActiveView<NS: INetworkService>: View {
    // Viewmodel
    @StateObject private var vm: ViewModel<NS>
    // State
    @State private var exitWarningConfirm: Bool = false
    @State private var displayCopied: Bool = false

    init(vm: ViewModel<NS>) {
        self._vm = .init(wrappedValue: vm)
    }

    var body: some View {
        VStack(spacing: 20) {
            header
            profileHeader
            profileImage
            groupedInterests
            Spacer()
            meetBox
            Spacer()
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CoffeeColors.backgroundColor)
    }

    private var header: some View {
        Text("Your coffee mate is...")
            .foregroundColor(CoffeeColors.subText)
            .font(.system(size: 20))
    }

    private var profileHeader: some View {
        let text = vm.name.flatten(loadingState: " ", errorState: "[Data error]")
        return Text(text)
            .foregroundColor(Color("TextColor"))
            .font(.title)
            .fontWeight(.bold)
    }

    @ViewBuilder
    private var profileImage: some View {
        let minSize: CGFloat = 100.0
        let maxSize: CGFloat = 200.0

        Group {
            switch vm.image {
            case .loaded(let image):
                Image(uiImage: image).resizable().aspectRatio(contentMode: .fit)
            case .loading:
                loadingImage
            case .error:
                Label("Network Error", systemImage: "wifi.slash").labelStyle(.titleAndIcon)
            }
        }
        .frame(minWidth: minSize, maxWidth: maxSize, minHeight: minSize, maxHeight: maxSize)
    }

    private var loadingImage: some View {
        ZStack {
            Circle().foregroundColor(Color(uiColor: .label).opacity(0.3))
            ProgressView().progressViewStyle(.circular)
        }
    }

    private var groupedInterests: some View {
        let spacing = Array(repeating: " ", count: 16).joined()
        return GroupedLabels(
            labels: vm.interests.flatten(loadingState: Array(repeating: spacing, count: 3), errorState: []),
            labelsPerRow: 2
        )
    }

    private var meetBox: some View {
        VStack(spacing: 20) {
            Text("Tell them where to meet you:").foregroundColor(CoffeeColors.meetViewBackground).bold()
            connectButton
        }
        .padding()
        .background(CoffeeColors.innerBox.clipShape(RoundedRectangle(cornerRadius: 10)))
        .padding(.horizontal)
    }

    private var connectButton: some View {
        let url: URL? = {
            if case .loaded(let url) = vm.link { return url }
            return nil
        }()
        let action = {
            if let url = url { UIApplication.shared.open(url) }
        }

        return Button(action: action) {
            Text("Connect")
                .foregroundColor(CoffeeColors.meetViewBackground)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .disabled(url == nil)
    }
}

// MARK: - ViewModel

extension MeetActiveView {
    final class ViewModel<NS: INetworkService>: ObservableObject {
        // State
        @Published private(set) var name = Loadable<String, Error>.loading
        @Published private(set) var image = Loadable<UIImage, Error>.loading
        @Published private(set) var link = Loadable<URL?, Error>.loading
        @Published private(set) var interests = Loadable<[String], Error>.loading
        // Dependencies
        private let service: NS

        init(service: NS, matchId: Person.ID?) {
            self.service = service
            loadProfile(id: matchId)
        }

        private func loadProfile(id: Person.ID?) {
            guard let id = id else { return }

            service.loadUserInfo(id) { [weak self] (result) in
                switch result {
                case .success(let person):
                    self?.name = .loaded(person.fullName)
                    self?.image = .loaded(UIImage(named: "PotentialMatch") ?? .init())  // Stub pic
                    self?.link = .loaded(URL(string: "https://t.me/myra5hik"))          // Stub link
                    self?.interests = .loaded(person.interests.map({ $0.title }))
                case .failure(let error):
                    self?.name = .error(error)
                    self?.image = .error(error)
                    self?.link = .error(error)
                    self?.interests = .error(error)
                }
            }
        }
    }
}

// MARK: - Previews

struct MeetActiveView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://t.me/myra5hik")
        let image = UIImage(named: "PotentialMatch")
        let interests: [DiscussionTopic] = [.coding, .swift, .skiing]

        return MeetActiveView<NetworkService<FirebaseManager>>(vm: .init(
            name: .loaded("Valerine Constantine"),
            image: (image != nil) ? .loaded(image!) : .error(URLError(.badURL)),
            link: .loaded(url),
            interests: .loaded(interests.map({ $0.title }))
        ))
    }
}

fileprivate extension MeetActiveView.ViewModel {
    convenience init(
        name: Loadable<String, Error>,
        image: Loadable<UIImage, Error>,
        link: Loadable<URL?, Error>,
        interests: Loadable<[String], Error>
    ) {
        self.init(service: NetworkService(manager: FirebaseManager()) as! NS, matchId: nil)
        self.name = name
        self.image = image
        self.link = link
        self.interests = interests
    }
}
