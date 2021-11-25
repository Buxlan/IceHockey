//
//  SportEventCreator.swift.swift
//  IceHockey
//
//  Created by  Buxlan on 11/6/21.
//

import Firebase

struct SportEventCreator {
    
    func create(snapshot: DataSnapshot,
                with completionHandler: @escaping () -> Void)
    -> SportEvent? {
        
        let uid = snapshot.key
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        let type = getType(dict)
        
        switch type {
        case .event:
            let builder = SportNewsBuilder(objectIdentifier: uid)
            builder.dict = dict
            builder.build(completionHandler: completionHandler)
            return builder.getResult()
        case .match:
            let builder = MatchResultBuilder(objectIdentifier: uid)
            builder.dict = dict
            builder.build(completionHandler: completionHandler)
            return builder.getResult()
        default:
            return nil
        }
    }
    
    func makeDatabasePart(from snapshot: DataSnapshot)
    -> SportEventDatabaseFlowData? {
        
        let objectIdentifier = snapshot.key
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        let type = getType(dict)
        switch type {
        case .event:
            return SportNewsDatabaseFlowDataImpl(key: objectIdentifier, dict: dict)
        case .match:
            return MatchResultDatabaseFlowDataImpl(key: objectIdentifier, dict: dict)
        default:
            return nil
        }
    }
    
    private func getType(_ dict: [String: Any]) -> SportEventType? {
        guard let rawType = dict["type"] as? Int,
              let type = SportEventType(rawValue: rawType) else { return nil }
        return type
    }
    
}
