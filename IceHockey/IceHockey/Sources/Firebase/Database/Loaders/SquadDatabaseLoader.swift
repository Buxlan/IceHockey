//
//  ClubDatabaseLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/22/21.
//

import Firebase

class SquadDatabaseLoader: FirebaseDatabaseLoader {
    
    // MARK: - Properties
    
    let objectIdentifier: String
    typealias DataType = SquadDatabaseFlowDataImpl
    
    private var databaseRootPath = "squads"
    internal lazy var databaseQuery: DatabaseQuery = {
        FirebaseManager.shared.databaseManager
            .root
            .child(databaseRootPath)
            .child(objectIdentifier)
    }()
    
    // MARK: - Lifecircle
    
    required init(objectIdentifier: String) {
        self.objectIdentifier = objectIdentifier
    }
    
}
