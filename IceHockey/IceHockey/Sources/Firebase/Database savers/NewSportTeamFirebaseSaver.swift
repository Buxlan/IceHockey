//
//  NewSportTeamFirebaseSaver.swift
//  IceHockey
//
//  Created by  Buxlan on 10/30/21.
//

import Firebase

struct NewSportTeamFirebaseSaver {
    
    // MARK: - Properties
    
    typealias DataType = Club
    internal let object: DataType
    
    internal var eventsDatabaseReference: DatabaseReference {
        FirebaseManager.shared.databaseManager.root.child("teams")
    }
    
    internal var imagesDatabaseReference: DatabaseReference {
        FirebaseManager.shared.databaseManager.root.child("images")
    }
    
    internal var imagesStorageReference: StorageReference {
        let ref = FirebaseManager.shared.storageManager.root.child("teams")
        return ref
    }
    
    internal var eventReference: DatabaseReference {
        var ref: DatabaseReference
        if object.isNew {
            ref = eventsDatabaseReference.childByAutoId()
        } else {
            ref = eventsDatabaseReference.child(object.objectIdentifier)
        }
        return ref
    }
        
    // MARK: - Lifecircle
    
    init(object: DataType) {
        self.object = object
    }
    
    // MARK: - Helper functions
    
    func save() throws {
        
        let dataDict = object.encode()
        
        eventReference.setValue(dataDict) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            guard let objectId = ref.key else {
                return
            }
            let imagesManager = ImagesManager.shared
            let imageIDs = [object.smallLogoID, object.largeLogoID]
            for imageId in imageIDs {
                let imageName = ImagesManager.shared.getImageName(withID: imageId)
                let imageRef = imagesDatabaseReference.child(imageId)
                imageRef.setValue(imageName)
                let ref = imagesStorageReference.child(objectId).child(imageName)
                if let image = ImagesManager.shared.getCachedImage(withName: imageName),
                   let data = image.pngData() {
                    let task = ref.putData(data)
                    imagesManager.appendUploadTask(task)
                }
            }
        }
    }
}
