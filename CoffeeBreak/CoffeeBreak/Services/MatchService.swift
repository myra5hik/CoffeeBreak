//
//  MatchService.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 08.12.2022.
//

import Foundation
import Combine

// MARK: - IMatchService

protocol IMatchService: ObservableObject {
    var matchState: MatchState { get }
    var readyForRequests: Bool { get }
    func requestCoffeeBreak()
    func cancelCoffeeBreakRequest()
}

enum MatchState: Equatable {
    /// State before connection to the server is established
    case uninitiated
    // States after the connection is established which guarantee synced state
    case idle
    case searching
    case match(with: Person.ID)
    case error(Error)
    
    static func == (lhs: MatchState, rhs: MatchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.searching, .searching): return true
        case (.match(with: let a), .match(with: let b)): return a == b
        case (.error(let a), .error(let b)): return a.localizedDescription == b.localizedDescription
        default: return false
        }
    }
}

// MARK: - MatchService Implementation

final class MatchService<NS: INetworkService, US: IUserService>: ObservableObject, IMatchService {
    // State
    @Published private(set) var matchState: MatchState = .uninitiated {
        didSet { print("Match service: \(matchState)") }
    }
    var readyForRequests: Bool { return matchState == .idle && currentUser != nil }
    private var currentUserQueuePosition: MeetupQueueElement.ID?
    // Dependencies
    private let networkService: NS
    private var currentUser: Person?
    private let userService: US
    // Etc
    private var queueSubscription: INetworkService.NetworkServiceSubscription?
    private var loungeRoomsSubscription: INetworkService.NetworkServiceSubscription?
    private var bag = Set<AnyCancellable>()

    init(networkService: NS, userService: US) {
        self.networkService = networkService
        self.userService = userService
        // Required to trigger Firebase after App's didFinishLaunching / FB configuration
        DispatchQueue.main.async { [weak self] in
            self?.subscribeToLoungeRoomUpdates()
            self?.subscribeToUserService()
        }
    }

    deinit {
        cancelCoffeeBreakRequest()
        unsubscribeFromLoungeRoomUpdates()
        unsubscribeFromQueueUpdates()
    }

    func requestCoffeeBreak() {
        // Avoids requesting unless in idle mode
        guard readyForRequests, let currentUser = currentUser else { return }
        // Sets internal state
        matchState = .searching
        // Adds request to the server
        networkService.add(meetupQueueElement: MeetupQueueElement(
            id: UUID().uuidString,
            timeCreated: .now,
            timeExpires: .now + Constants.queueElementExpiration,
            topicIds: currentUser.interests.map({ $0.rawValue }),
            userId: currentUser.id)
        )
        // Subscribes to network service meetup queue updates
        subscribeToQueueUpdates(ownInterests: currentUser.interests)
    }
    
    func cancelCoffeeBreakRequest() {
        guard matchState == .searching else { return }
        removeCurrentUserFromQueue()
        unsubscribeFromQueueUpdates()
    }
}

// MARK: - Subscribing / unsubscribing to updates

private extension MatchService {
    func subscribeToLoungeRoomUpdates() {
        loungeRoomsSubscription = networkService.subscribeToLoungeRooms { [weak self] (result) in
            switch result {
            case .success(let rooms): self?.processLoungeRooms(rooms)
            case .failure(let error): self?.matchState = .error(error)
            }
        }
    }

    func subscribeToQueueUpdates(ownInterests: [DiscussionTopic]) {
        queueSubscription = networkService.subscribeToMeetupQueue { [weak self] (state) in
            if case .success(let queue) = state {
                self?.processMeetupQueue(queue, ownInterests: ownInterests)
            }
        }
    }
    
    func unsubscribeFromQueueUpdates() {
        if let subscription = queueSubscription {
            networkService.unsubscribe(subscription)
            queueSubscription = nil
        }
    }

    func unsubscribeFromLoungeRoomUpdates() {
        if let subscription = loungeRoomsSubscription {
            networkService.unsubscribe(subscription)
            loungeRoomsSubscription = nil
        }
    }

    func subscribeToUserService() {
        userService.currentUser.publisher.sink { [weak self] person in
            self?.cancelCoffeeBreakRequest()
            self?.unsubscribeFromLoungeRoomUpdates()
            self?.unsubscribeFromQueueUpdates()
            self?.matchState = .uninitiated
            self?.currentUser = person
            self?.subscribeToLoungeRoomUpdates()
        }
        .store(in: &bag)
    }
}

// MARK: - Processing updates

private extension MatchService {
    func processLoungeRooms(_ rooms: [LoungeRoom]) {
        guard let currentUser = currentUser else { return }
        for room in rooms {
            if room.timeExpires < .now { networkService.removeLoungeRoom(room.id); continue }
            if !room.members.contains(currentUser.id) { continue }
            // Present in a room at this point
            guard let other = room.members.first(where: { $0 != currentUser.id }) else { return }
            matchState = .match(with: other)
            unsubscribeFromQueueUpdates()
            return
        }
        // Not present in any of the rooms
        matchState = (matchState == .searching) ? .searching : .idle
    }

    func processMeetupQueue(_ queue: [MeetupQueueElement], ownInterests: [DiscussionTopic]) {
        // Removes expired items
        removeExpiredItems(queue)
        // Avoids proceeding unless in searching mode / unauthed
        guard matchState == .searching, let currentUser = currentUser else { return }
        // Looks for a match
        let ownInterests = Set(ownInterests.map({ $0.rawValue }))
        let sortedQueue = queue.sorted(by: { $0.timeCreated <= $1.timeCreated })
        guard let ownPosition = sortedQueue.firstIndex(where: { $0.userId == currentUser.id }) else {
            matchState = .idle
            return
        }
        // Present in the queue
        currentUserQueuePosition = sortedQueue[ownPosition].id
        // Resolves if should lead or yield
        if shouldAssumeLeadershipPosition(
            interestsBefore: sortedQueue[0 ..< ownPosition].map({ $0.topicIds }),
            interestsAfterInclSelf: sortedQueue[ownPosition ..< sortedQueue.endIndex].map({ $0.topicIds })
        ) {
            // In leading position here
            if let match = sortedQueue[(ownPosition + 1)...].firstIndex(where: { !ownInterests.intersection($0.topicIds).isEmpty }) {
                let counterpart = sortedQueue[match].userId
                // Removes both from queue
                networkService.removeMeetupQueueElement(sortedQueue[ownPosition].id)
                networkService.removeMeetupQueueElement(sortedQueue[match].id)
                // Add both to a lounge room
                networkService.add(loungeRoom: LoungeRoom(
                    id: UUID().uuidString,
                    members: [currentUser.id, counterpart],
                    timeCreated: .now,
                    timeExpires: .now + Constants.loungeRoomExpiration)
                )
            }
        }
    }

    ///
    /// The client first added to the queue is responsible to manipulate the server state. For a position of 0 in the sorted queue, always leads.
    /// For other positions, leads if clients before the current client are guaranteed to have no intersecting interests with the rest of the queue.
    ///
    func shouldAssumeLeadershipPosition(interestsBefore: [[String]], interestsAfterInclSelf: [[String]]) -> Bool {
        let interestsBefore = interestsBefore
            .map({ Set($0) }).reduce(into: Set<String>(), { $0 = $0.union($1) })
        let interestsAfterIncludingSelf = interestsAfterInclSelf
            .map({ Set($0) }).reduce(into: Set<String>(), { $0 = $0.union($1) })

        if interestsBefore.intersection(interestsAfterIncludingSelf).isEmpty {
            return true
        } else {
            return false
        }
    }

    func removeCurrentUserFromQueue() {
        if let position = currentUserQueuePosition {
            networkService.removeMeetupQueueElement(position)
        }
    }

    func removeExpiredItems(_ queue: [MeetupQueueElement]) {
        let now = Date()
        for element in queue {
            if element.timeExpires < now {
                networkService.removeMeetupQueueElement(element.id)
            }
        }
    }
}

// MARK: - Constants

extension MatchService {
    enum Constants {
        static var queueElementExpiration: TimeInterval { 5 * 60 }
        static var loungeRoomExpiration: TimeInterval { 15 * 60 }
    }
}
