//
//  MatchResultDatabaseFlowData.swift
//  IceHockey
//
//  Created by  Buxlan on 11/18/21.
//

import UIKit
import Firebase

protocol MatchResultDatabaseFlowData: SportEventDatabaseFlowData {
    var homeTeam: String { get set }
    var awayTeam: String { get set }
    var homeTeamScore: Int { get set }
    var awayTeamScore: Int { get set }
    var stadium: String { get set }
}

struct EmptyMatchResultDatabaseFlowData: MatchResultDatabaseFlowData {
    
    var objectIdentifier: String = ""
    var type: SportEventType = .match
    var title: String = ""
    var text: String = ""
    var date: Date = Date()
    var authorID: String = ""
    var order: Int = 0
    var homeTeam: String = ""
    var awayTeam: String = ""
    var homeTeamScore: Int = 0
    var awayTeamScore: Int = 0
    var stadium: String = ""    
    
}

struct MatchResultDatabaseFlowDataImpl: MatchResultDatabaseFlowData {
    
    var objectIdentifier: String
    var type: SportEventType = .match
    var title: String
    var text: String
    var date: Date = Date()
    var authorID: String
    var order: Int = 0
    var homeTeam: String
    var awayTeam: String
    var homeTeamScore: Int
    var awayTeamScore: Int
    var stadium: String
    
    init(key: String, dict: [String: Any]) {
        self.objectIdentifier = key
        self.authorID = dict["author"] as? String ?? ""
        self.homeTeam = dict["homeTeam"] as? String ?? ""
        self.awayTeam = dict["awayTeam"] as? String ?? ""
        self.homeTeamScore = dict["homeTeamScore"] as? Int ?? 0
        self.awayTeamScore = dict["awayTeamScore"] as? Int ?? 0
        self.stadium = dict["stadium"] as? String ?? ""
        self.title = dict["title"] as? String ?? ""
        self.text = dict["text"] as? String ?? ""
        self.order = dict["order"] as? Int ?? 0
        
        self.type = .match
        if let rawType = dict["type"] as? Int,
           let type = SportEventType(rawValue: rawType) {
            self.type = type
        }
        
        self.date = Date()
        if let dateInterval = dict["date"] as? Int {
            self.date = Date(timeIntervalSince1970: TimeInterval(dateInterval))
        }
    }
    
    init?(snapshot: DataSnapshot) {
        let objectIdentifier = snapshot.key
        guard let dict = snapshot.value as? [String: Any] else {
            return nil
        }
        self.init(key: objectIdentifier, dict: dict)
    }
    
}
