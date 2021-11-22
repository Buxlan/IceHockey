//
//  TeamDatabaseFlowData.swift
//  IceHockey
//
//  Created by  Buxlan on 11/22/21.
//

import UIKit
import Firebase

protocol TeamDatabaseFlowData {
    var objectIdentifier: String { get set }
    var address: String { get set }
    var copyright: String { get set }
    var displayName: String { get set }
    var email: String { get set }
    var largeLogoID: String { get set }
    var smallLogoID: String { get set }
    var location: Coord? { get set }
    var phone: String { get set }
    var webSite: String { get set }
    var squadsIDs: [String] { get set }
}

struct DefaultTeamDatabaseFlowData: TeamDatabaseFlowData {
    var objectIdentifier: String = ""
    var address: String = ""
    var copyright: String = ""
    var displayName: String = ""
    var email: String = ""
    var largeLogoID: String = ""
    var smallLogoID: String = ""
    var location: Coord?
    var phone: String = ""
    var webSite: String = ""
    var squadsIDs: [String] = []
}

struct TeamDatabaseFlowDataImpl: TeamDatabaseFlowData {
    var objectIdentifier: String
    var address: String
    var copyright: String
    var displayName: String
    var email: String
    var largeLogoID: String
    var smallLogoID: String
    var location: Coord?
    var phone: String
    var webSite: String
    var squadsIDs: [String] = []
        
    init?(snapshot: DataSnapshot) {
        let uid = snapshot.key
        guard let dict = snapshot.value as? [String: Any] else {
            return nil
        }
        self.init(key: uid, dict: dict)
    }
    
    init(key: String, dict: [String: Any]) {
        self.objectIdentifier = key
        self.address = dict["address"] as? String ?? ""
        self.copyright = dict["copyright"] as? String ?? ""
        self.displayName = dict["displayName"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.largeLogoID = dict["largeLogo"] as? String ?? ""
        self.smallLogoID = dict["smallLogo"] as? String ?? ""
        self.phone = dict["phone"] as? String ?? ""
        self.webSite = dict["webSite"] as? String ?? ""
        self.squadsIDs = dict["squads"] as? [String] ?? []
                
        if let locationDict = dict["location"] as? [String: Double] {
            self.location = Coord(dictionary: locationDict)
        }
//        if let coordDict = dict["location"] as? [String: NSNumber],
//           let latitude = coordDict["latitude"] as? Double,
//           let longitude = coordDict["longitude"] as? Double {
//            self.location = Coord(longitude: longitude, latitude: latitude)
//        }        
    }
    
}
