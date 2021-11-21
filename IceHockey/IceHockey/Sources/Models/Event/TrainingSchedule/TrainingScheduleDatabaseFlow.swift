//
//  TrainingScheduleDatabaseFlow.swift
//  IceHockey
//
//  Created by  Buxlan on 11/21/21.
//

import UIKit

protocol TrainingScheduleDatabaseFlowData {
    var uid: String { get set }
    var title: String { get set }
    var imageIDs: [String] { get set }
    var boldText: String { get set }
}

struct DefaultTrainingScheduleDatabaseFlowData: TrainingScheduleDatabaseFlowData {
        
    // Database Fields
    var uid: String
    var title: String
    var imageIDs: [String]
    var boldText: String
    
    init() {
        uid = ""
        title = ""
        imageIDs = []
        boldText = ""
    }
}

struct TrainingScheduleDatabaseFlowDataImpl: TrainingScheduleDatabaseFlowData {
    
    var likesInfo = EventLikesInfo()
    var viewsInfo = EventViewsInfo()
    var author: SportUser?
    internal var isLoading: Bool = false
    
    // Database Fields
    var uid: String
    var authorID: String
    var title: String
    var text: String
    var boldText: String
    var type: SportEventType
    var date: Date
    internal var imageIDs: [String] = []
    var order: Int
    
    init(uid: String,
         authorID: String,
         title: String,
         text: String,
         boldText: String,
         imageIDs: [String],
         date: Date,
         type: SportEventType = .event,
         order: Int) {
        self.uid = uid
        self.authorID = authorID
        self.title = title
        self.text = text
        self.date = date
        self.type = type
        self.boldText = boldText
        self.imageIDs = imageIDs
        self.order = order
    }
    
    internal init() {
        self.uid = ""
        self.title = .empty
        self.text = .empty
        self.date = Date()
        self.type = .event
        self.boldText = ""
        self.imageIDs = []
        self.order = 0
        self.authorID = ""
    }
    
    init(key: String, dict: [String: Any]) {
        self.uid = key
        self.authorID = dict["author"] as? String ?? ""
        self.title = dict["title"] as? String ?? ""
        self.text = dict["text"] as? String ?? ""
        self.boldText = dict["boldText"] as? String ?? ""
        self.imageIDs = dict["images"] as? [String] ?? []
        self.order = dict["order"] as? Int ?? 0
        
        self.type = .event
        if let rawType = dict["type"] as? Int,
           let type = SportEventType(rawValue: rawType) {
            self.type = type
        }
        
        self.date = Date()
        if let dateInterval = dict["date"] as? Int {
            self.date = Date(timeIntervalSince1970: TimeInterval(dateInterval))
        }
    }
    
}
