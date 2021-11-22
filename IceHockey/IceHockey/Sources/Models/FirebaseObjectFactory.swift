//
//  FirebaseObjectFactory.swift
//  IceHockey
//
//  Created by  Buxlan on 11/18/21.
//

import Firebase

struct FirebaseObjectFactory {
    
    func makeTeam(with objectIdentifier: String,
                  completionHandler: @escaping (SportTeam?) -> Void)
    -> SportTeam? {
        let builder = TeamBuilder(objectIdentifier: objectIdentifier)        
        builder.build(completionHandler: completionHandler)
        let object = builder.getResult()
        return object
    }
    
    func makeWorkoutSchedule(from snapshot: DataSnapshot) -> WorkoutSchedule? {
        let builder = WorkoutScheduleBuilder(snapshot: snapshot)
        builder.build()
        let object = builder.getInstance()
        return object
    }
    
    func create<DataType: FirebaseObject>(objectType: DataType.Type,
                                          from snapshot: DataSnapshot,
                                          with completionHandler: @escaping (DataType?) -> Void)
    -> DataType? {
        
        switch objectType {
        case is SportEvent.Type:
            let factory = SportEventCreator()
            let handler: (SportEvent?) -> Void = { object in
                let casted = object as? DataType
                completionHandler(casted)
            }
            let object = factory.create(snapshot: snapshot, with: handler) as? DataType
            return object
        case is SportUser.Type:
            let builder = SportUserBuilder(key: snapshot.key)
            let handler: (SportUser?) -> Void = { object in
                let casted = object as? DataType
                completionHandler(casted)
            }
            builder.build(completionHandler: handler)
            let object = builder.getResult() as? DataType
            return object
        default:
            return nil
        }
    }
    
}
