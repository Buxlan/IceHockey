//
//  SportUserDatabaseLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/24/21.
//

import Firebase

protocol SnapshotInitiable {
    init?(snapshot: DataSnapshot)
}
class SportUserDatabaseLoader: FirebaseDatabaseLoader {
    
    typealias DataType = SportUserDatabaseFlowDataImpl
    
    // MARK: - Properties
    
    let objectIdentifier: String
    
    private var databaseRootPath = "users"
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
