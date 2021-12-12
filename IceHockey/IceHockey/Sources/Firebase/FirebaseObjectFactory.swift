//
//  FirebaseObjectFactory.swift
//  IceHockey
//
//  Created by  Buxlan on 11/18/21.
//

import Firebase

struct FirebaseObjectFactory {
    
    // MARK: - Properties
    
    static let shared = FirebaseObjectFactory()
    
    // MARK: - Lifecircle
    
    private init() {
    }
    
    // MARK: - Factory methods
    
    func makeSportNews(with objectIdentifier: String,
                       completionHandler: @escaping () -> Void)
    -> SportNews {
        let builder = SportNewsBuilder(objectIdentifier: objectIdentifier)
        builder.build(completionHandler: completionHandler)
        let object = builder.getResult()
        return object
    }
    
    func makeMatchResult(with objectIdentifier: String,
                         completionHandler: @escaping () -> Void)
    -> MatchResult {
        let builder = MatchResultBuilder(objectIdentifier: objectIdentifier)
        builder.build(completionHandler: completionHandler)
        let object = builder.getResult()
        return object
    }
    
    func makeSquad(with objectIdentifier: String,
                   completionHandler: @escaping () -> Void)
    -> Squad {
        let builder = SquadBuilder(objectIdentifier: objectIdentifier)
        builder.build(completionHandler: completionHandler)
        let object = builder.getResult()
        return object
    }
    
//    func makeEvent(with objectIdentifier: String,
//                   completionHandler: @escaping () -> Void)
//    -> SportEvent {
//        let builder = SquadBuilder(objectIdentifier: objectIdentifier)
//        builder.build(completionHandler: completionHandler)
//        let object = builder.getResult()
//        return object
//    }
    
    func makeWorkoutSchedule(from snapshot: DataSnapshot)
    -> WorkoutSchedule? {
        let builder = WorkoutScheduleBuilder(snapshot: snapshot)
        builder.build()
        let object = builder.getInstance()
        return object
    }
    
    func create<DataType: FirebaseObject>(objectType: DataType.Type,
                                          from snapshot: DataSnapshot,
                                          with completionHandler: @escaping () -> Void)
    -> DataType? {
        
        switch objectType {
        case is SportEvent.Type:
            let factory = SportEventCreator()
            let handler: () -> Void = {
                completionHandler()
            }
            let object = factory.create(snapshot: snapshot, with: handler) as? DataType
            return object
        case is SportUser.Type:
            let builder = SportUserBuilder(objectIdentifier: snapshot.key)
            let handler: () -> Void = {
                completionHandler()
            }
            builder.build(completionHandler: handler)
            let object = builder.getResult() as? DataType
            return object
        default:
            return nil
        }
    }
    
}
