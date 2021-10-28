//
//  DatabaseManager.swift
//  IceHockey
//
//  Created by  Buxlan on 10/6/21.
//
import Firebase

protocol FirebaseManagerInterface {
    func configureFirebase()
}

struct FirebaseManager: FirebaseManagerInterface {
    
    // MARK: - Properties
    
    static let shared = FirebaseManager()
    
    let databaseManager = RealtimeDatabaseManager()
    let storageManager = FirebaseStorageManager()
    
    // MARK: - Lifecircle
    
    // MARK: - Helper functions
    
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func delete(_ object: SportTeam) throws {
        let remover = SportTeamFirebaseRemover(object: object)
        try remover.remove {
            print("!!!removed!!!")
        }
    }
    
}
