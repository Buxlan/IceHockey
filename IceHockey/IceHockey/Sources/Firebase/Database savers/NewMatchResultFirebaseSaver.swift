//
//  NewMatchResultFirebaseSaver.swift
//  IceHockey
//
//  Created by  Buxlan on 11/8/21.
//

import Firebase

struct NewMatchResultFirebaseSaver: SportEventFirebaseSaver {
    
    // MARK: - Properties
    
    typealias DataType = SportEvent
    internal let object: DataType
    
    internal var eventsDatabaseReference: DatabaseReference {
        FirebaseManager.shared.databaseManager.root.child("events")
    }
    
    internal var imagesDatabaseReference: DatabaseReference {
        FirebaseManager.shared.databaseManager.root.child("images")
    }
    
    internal var imagesStorageReference: StorageReference {
        let ref = FirebaseManager.shared.storageManager.root.child("events")
        return ref
    }
    
    internal var eventReference: DatabaseReference {
        var ref: DatabaseReference
        if object.isNew {
            ref = eventsDatabaseReference.childByAutoId()
        } else {
            ref = eventsDatabaseReference.child(object.uid)
        }
        return ref
    }
    
    private var orderValue: Int {
        // for order purposes
        var dateComponent = DateComponents()
        dateComponent.calendar = Calendar.current
        dateComponent.year = 2024
        guard let templateDate = dateComponent.date else {
            fatalError()
        }
        let order = Int(templateDate.timeIntervalSince(object.date))
        return order
    }
    
    // MARK: - Lifecircle
    
    init(object: DataType) {
        self.object = object
    }
    
    // MARK: - Helper functions
    
    func save(completionHandler: @escaping () -> Void) throws {
        guard let object = self.object as? MatchResult else {
            throw SportEventSaveError.wrongInput
        }
        var dataDict = object.prepareDataForSaving()
        dataDict["order"] = orderValue
        
        eventReference.setValue(dataDict) { (error, ref) in
            if let error = error {
                print(error)
                completionHandler()
                return
            }
            guard let _ = ref.key else {
                completionHandler()
                return
            }
            completionHandler()
        }
    }
}

