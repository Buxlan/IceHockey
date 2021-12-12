//
//  SportUserDatabaseFlowData.swift
//  IceHockey
//
//  Created by  Buxlan on 11/17/21.
//

import Firebase

protocol SportUserDatabaseFlowData: FirebaseObject, SnapshotInitiable {
    var objectIdentifier: String { get set }
    var imageID: String { get set }
    var displayName: String { get set }
    static var empty: SportUserDatabaseFlowData { get }
    init?(snapshot: DataSnapshot)
}

struct SportUserDatabaseFlowDataImpl: SportUserDatabaseFlowData {

    static var empty: SportUserDatabaseFlowData {
        return Self()
    }
    
    var objectIdentifier: String
    var imageID: String
    var displayName: String
    
    init() {
        self.objectIdentifier = ""
        self.imageID = ""
        self.displayName = ""
    }
    
    init(objectIdentifier: String,
         displayName: String,
         imageID: String) {
        self.objectIdentifier = objectIdentifier
        self.imageID = imageID
        self.displayName = displayName
    }
    
    init(key: String, dict: [String: Any]) {                
        self.objectIdentifier = key
        self.imageID = dict["image"] as? String ?? ""
        self.displayName = dict["displayName"] as? String ?? ""
    }
    
    init?(snapshot: DataSnapshot) {
        guard !(snapshot.value is NSNull),
              let dict = snapshot.value as? [String: Any] else {
                  return nil
              }
        self.init(key: snapshot.key, dict: dict)
    }
    
}
