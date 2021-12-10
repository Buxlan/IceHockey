//
//  HockeyPlayer.swift
//  IceHockey
//
//  Created by  Buxlan on 9/6/21.
//
import Firebase

struct SportPlayer: FirebaseObject, Codable {
    
    var objectIdentifier: String
    var displayName: String
    var smallImage: String = ""
    var largeImage: String = ""
    var position: PlayerRole
    var number: String
    
    // MARK: - Lifecircle
    
    init?(snapshot: DataSnapshot) {
        let objectIdentifier = snapshot.key
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        self.init(key: objectIdentifier, dict: dict)
    }
    
    init?(key: String, dict: [String: Any]) {
        guard let displayName = dict["displayName"] as? String else { return nil }
        guard let number = dict["number"] as? String else { return nil }
        let type = (dict["type"] as? Int) ?? 0
        let position = PlayerRole(rawValue: type)
                
        self.objectIdentifier = key
        self.displayName = displayName
        self.number = number
        self.position = position
    }
    
    // MARK: - Helper methods
    
    func save() throws {
        
    }
    
    func delete() throws {
//        try FirebaseManager.shared.delete(self)
    }
    
    static func getObject(by uid: String, completionHandler handler: @escaping (SportPlayer?) -> Void) {
        
    }
    
}
