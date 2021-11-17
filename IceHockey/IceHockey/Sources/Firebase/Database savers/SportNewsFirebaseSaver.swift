//
//  NewSportNewsFirebaseSaver.swift
//  IceHockey
//
//  Created by  Buxlan on 10/27/21.
//

import Firebase

struct SportNewsFirebaseSaver {
    
    // MARK: - Properties
    
    typealias DataType = SportNews
    internal var object: DataType
    
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
    
    func save() throws {
        if object.isNew {
            try saveExisting()
        } else {
            try saveNew()
        }
    }
    
    func prepareDataForSaving(for object: DataType) -> [String: Any] {
        let interval = object.date.timeIntervalSince1970
        let dict: [String: Any] = [
            "uid": object.uid,
            "author": object.author,
            "title": object.title,
            "text": object.text,
            "boldText": object.boldText,
            "type": object.type.rawValue,
            "date": Int(interval),
            "images": object.imageIDs,
            "order": orderValue
        ]
        return dict
    }
    
    func saveNew() throws {
        
        var dataDict = prepareDataForSaving(for: object)
        
        eventReference.setValue(dataDict) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            guard let eventId = ref.key else {
                return
            }
            let imagesManager = ImagesManager.shared
            for imageId in object.imageIDs {
                let imageName = ImagesManager.shared.getImageName(withID: imageId)
                let imageRef = imagesDatabaseReference.child(imageId)
                imageRef.setValue(imageName)
                let ref = imagesStorageReference.child(eventId).child(imageName)
                if let image = ImagesManager.shared.getCachedImage(withName: imageName),
                   let data = image.pngData() {
                    let task = ref.putData(data)
                    imagesManager.appendUploadTask(task)
                }
            }
        }
    }
    
    func saveExisting() throws {
        
//        guard let object = self.object as? SportNews else {
//            throw SportEventSaveError.wrongInput
//        }
//
//        var dataDict = object.prepareDataForSaving()
//        dataDict["order"] = orderValue
//
//        eventReference.child("images").getData { (error, snapshot) in
//            if let error = error {
//                print(error)
//                return
//            }
//            let oldImageIDs = snapshot.value as? [String] ?? []
//
//            for imageId in oldImageIDs {
//                if object.imageIDs.firstIndex(of: imageId) != nil {
//                    continue
//                }
//                // need to remove image from storage
//                let imageName = ImagesManager.shared.getImageName(withID: imageId)
//                let imageStorageRef = imagesStorageReference.child(object.uid).child(imageName)
//                imageStorageRef.delete { (error) in
//                    if let error = error {
//                        print("An error occupied while deleting an image: \(error)")
//                    }
//                }
//            }
//
//            var newImageIds: [String] = []
//            for imageId in object.imageIDs {
//                if oldImageIDs.firstIndex(of: imageId) != nil {
//                    continue
//                }
//                newImageIds.append(imageId)
//            }
//
//            eventReference.setValue(dataDict) { (error, ref) in
//                if let error = error {
//                    print(error)
//                    return
//                }
//                guard let eventId = ref.key else {
//                    return
//                }
//                let imagesManager = ImagesManager.shared
//                for imageId in newImageIds {
//                    let imageName = ImagesManager.shared.getImageName(withID: imageId)
//                    let imageRef = imagesDatabaseReference.child(imageId)
//                    imageRef.setValue(imageName)
//                    let ref = imagesStorageReference.child(eventId).child(imageName)
//                    if let image = ImagesManager.shared.getCachedImage(withName: imageName),
//                       let data = image.pngData() {
//                        let task = ref.putData(data)
//                        imagesManager.appendUploadTask(task)
//                    }
//                }
//            }
//        }
    }
    
}