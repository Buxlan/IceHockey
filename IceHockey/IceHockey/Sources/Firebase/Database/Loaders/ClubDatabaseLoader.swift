//
//  ClubDatabaseLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/22/21.
//

import Firebase

class ClubDatabaseLoader: FirebaseLoader {
    
    // MARK: - Properties
    
    let objectIdentifier: String
    typealias DataType = ClubDatabaseFlowData
    typealias DataTypeImpl = ClubDatabaseFlowDataImpl
    
    private var databaseRootPath = "teams"
    private lazy var databaseQuery: DatabaseQuery = {
        FirebaseManager.shared.databaseManager
            .root
            .child(databaseRootPath)
            .child(objectIdentifier)
    }()
    
    // MARK: - Lifecircle
    
    init(objectIdentifier: String) {
        self.objectIdentifier = objectIdentifier
    }
    
    func load(completionHandler: @escaping (DataType?) -> Void) {
        guard !objectIdentifier.isEmpty else {
            completionHandler(nil)
            return
        }
        databaseQuery.getData { error, snapshot in
            assert(error == nil && !(snapshot.value is NSNull))
            let object = DataTypeImpl(snapshot: snapshot)
            completionHandler(object)
        }
    }
    
}
