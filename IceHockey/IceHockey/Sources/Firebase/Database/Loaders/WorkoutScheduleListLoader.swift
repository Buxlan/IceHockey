//
//  TrainingScheduleListLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/21/21.
//

import Firebase

class WorkoutScheduleListLoader {
    
    // MARK: - Properties
    
    var isLoading: Bool {
        return !loadingHandlers.isEmpty
    }
    private lazy var databaseQuery: DatabaseQuery = {
        FirebaseManager.shared.databaseManager
            .root
            .child(databaseRootPath)
            .queryLimited(toFirst: capacity)
    }()
       
    private var databaseRootPath = "trainingSchedule"
    private let capacity: UInt
    private var lastValue: String?
    private var endOfListIsReached: Bool = false
    
    private var factory = FirebaseObjectFactory.shared
    
    private var loadingHandlers: [String: (WorkoutSchedule?) -> Void] = [:]
    
    // MARK: - Lifecircle
    
    init(capacity: UInt = 50) {
        self.capacity = capacity
    }
    
    func flush() {
        lastValue = nil
    }
    
    func load(completionHandler: @escaping ([WorkoutSchedule]) -> Void) {
        if endOfListIsReached {
            return
        }
        var query = databaseQuery
        if let lastValue = lastValue {
            query = query.queryStarting(afterValue: lastValue)
        }
        var objects: [WorkoutSchedule] = []
        query.getData { [weak self] error, snapshot in
            guard let self = self else { return }
            assert(error == nil)
            if snapshot.childrenCount < self.capacity {
                self.endOfListIsReached = true
            }
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else {
                    continue
                }
                self.lastValue = child.key
                let object = self.factory.makeWorkoutSchedule(from: child)
                if let object = object {
                    self.lastValue = object.objectIdentifier
                    objects.append(object)
                }
            }
            completionHandler(objects)
        }
    }
    
}
