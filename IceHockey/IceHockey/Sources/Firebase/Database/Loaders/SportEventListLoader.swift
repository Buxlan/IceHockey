//
//  SportEventListLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/20/21.
//

import Firebase

class SportEventListLoader {
    
    // MARK: - Properties
    
    var isLoading: Bool {
        print("Loading handlers count: \(loadings.count)")
        return !loadings.isEmpty
    }
    
    private var databaseRootPath = "events"
    private lazy var collection = DataSnapshotsCollection(portionSize: portionSize)
    private lazy var iterator = DataSnapshotsIterator(collection: collection)
    
    private let portionSize: UInt
    private var endOfListIsReached: Bool = false
    
    private var loadings: [String: (SportEventCreator, () -> Void)] = [:]
    
    // MARK: - Lifecircle
    
    init(portionSize: UInt = 10) {
        self.portionSize = portionSize
    }
    
    deinit {
        print("deinit SportEventListLoader")
    }
    
    // MARK: - Helper methods
    
    func flush() {
        collection = DataSnapshotsCollection(portionSize: portionSize)
        iterator = DataSnapshotsIterator(collection: collection)
    }
    
    private func loadSnapshots(completionHandler: @escaping (Int) -> Void) {
        let query = prepareQuery()
        query.getData { [weak self] error, snapshot in
            assert(error == nil)
            var count = 0
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else {
                    return
                }
                self?.collection.appendItem(child)
                count += 1
            }
            completionHandler(count)
        }
    }
    
    private func prepareQuery() -> DatabaseQuery {
        var query: DatabaseQuery
        query = FirebaseManager.shared.databaseManager
            .root
            .child(databaseRootPath)
            .queryOrdered(byChild: "order")
            .queryLimited(toFirst: portionSize)
        if !collection.isEmpty {
            guard let objects = iterator.last(),
                  let snapshot = objects.items.last else {
                      assertionFailure()
                      return query
            }
            if let databasePart = SportEventCreator().makeDatabasePart(from: snapshot) {
                query = FirebaseManager.shared.databaseManager
                    .root
                    .child(databaseRootPath)
                    .queryOrdered(byChild: "order")
                    .queryStarting(afterValue: databasePart.order)
                    .queryLimited(toFirst: portionSize)
            }
        }
        return query
    }
    
    func getNextPortion(completionHandler: @escaping ([DataSnapshot]) -> Void) {
        if let data = iterator.next() {
            completionHandler(data.items)
        } else {
            loadSnapshots { [weak self] loadedSnapshotsCount in
                if loadedSnapshotsCount > 0 {
                    self?.getNextPortion(completionHandler: completionHandler)
                }
            }
        }
    }
    
    func load(eventListCompletionHandler: @escaping ([SportEvent]) -> Void,
              eventLoadedCompletionHandler: @escaping () -> Void) {
        var events: [SportEvent] = []
        getNextPortion { [weak self] snapshots in
            guard let self = self else { return }
            for snapshot in snapshots {
                let eventID = snapshot.key
                let completionHandler: () -> Void = { [weak self] in
                    guard let self = self else {
                        return                        
                    }
                    if let handlerIndex = self.loadings
                        .firstIndex(where: { (key, _) in
                        key == eventID
                    }) {
                        self.loadings.remove(at: handlerIndex)
                    }
                    eventLoadedCompletionHandler()
                }
                self.loadings[eventID] = (SportEventCreator(), completionHandler)
            }
            for snapshot in snapshots {
                let key = snapshot.key
                guard let (creator, handler) = self.loadings[key] else {
                    return
                }
                let event = creator.create(snapshot: snapshot, with: handler)
                if let event = event {
                    events.append(event)
                }
            }
            eventListCompletionHandler(events)
        }
    }
    
}
