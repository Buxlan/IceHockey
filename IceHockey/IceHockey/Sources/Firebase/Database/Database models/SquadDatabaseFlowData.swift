//
//  ClubDatabaseFlowData.swift
//  IceHockey
//
//  Created by  Buxlan on 11/22/21.
//

import UIKit
import Firebase

protocol SquadDatabaseFlowData: SnapshotInitiable {
    var objectIdentifier: String { get set }
    var displayName: String { get set }
    var headCoach: String { get set }
    init?(snapshot: DataSnapshot)
}

struct SquadDatabaseFlowDataImpl: SquadDatabaseFlowData {
    
    static let empty = Self()
    
    var objectIdentifier: String
    var displayName: String
    var headCoach: String
    
    init() {
        objectIdentifier = ""
        displayName = ""
        headCoach = ""
    }
        
    init?(snapshot: DataSnapshot) {
        let uid = snapshot.key
        guard let dict = snapshot.value as? [String: Any] else {
            return nil
        }
        self.init(key: uid, dict: dict)
    }
    
    init(key: String, dict: [String: Any]) {
        self.objectIdentifier = key
        self.displayName = dict["name"] as? String ?? ""
        self.headCoach = dict["headCoach"] as? String ?? ""
    }
    
}
