//
//  UserImageLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/24/21.
//

import Firebase

class UserImageLoader: FirebaseImagesLoader {
    
    internal var objectIdentifier: String
    internal lazy var imagesPath: String = "users/\(objectIdentifier)"
    internal var handlers: [String: (UIImage?) -> Void] = [:]
    internal var imagesIdentifiers: [String]
    
    convenience init(objectIdentifier: String,
                     imageIdentifier: String) {
        self.init(objectIdentifier: objectIdentifier, imagesIdentifiers: [imageIdentifier])
    }
    
    required internal init(objectIdentifier: String,
                           imagesIdentifiers: [String]) {
        self.objectIdentifier = objectIdentifier
        self.imagesIdentifiers = imagesIdentifiers
    }
    
}
