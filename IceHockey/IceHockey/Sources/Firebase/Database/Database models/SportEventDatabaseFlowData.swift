//
//  SportEventDatabaseFlowData.swift
//  IceHockey
//
//  Created by  Buxlan on 11/25/21.
//

import Foundation

protocol SportEventDatabaseFlowData: FirebaseObject {
    var type: SportEventType { get set }
    var date: Date { get set }
    var authorID: String { get set }
    var order: Int { get set }
    var title: String { get set }
    var text: String { get set }
}

struct EmptySportEventDatabaseFlowData: SportEventDatabaseFlowData {
    var type: SportEventType = .event
    var date: Date = Date()
    var authorID: String = ""
    var order: Int = 0
    var title: String = ""
    var text: String = ""
    var objectIdentifier: String = ""
}
