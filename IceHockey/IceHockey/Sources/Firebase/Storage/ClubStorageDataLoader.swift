//
//  ClubStorageDataLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/22/21.
//

import Firebase

class ClubStorageDataLoader: FirebaseImagesLoader {
    
    // MARK: - Properties
    internal var objectIdentifier: String
    internal lazy var imagesPath: String = "teams/\(objectIdentifier)"
    internal var handlers: [String: (UIImage?) -> Void] = [:]
    internal var imagesIdentifiers: [String]
        
    // MARK: - Lifecircle
    
    required init(objectIdentifier: String,
                  imagesIdentifiers: [String]) {
        self.objectIdentifier = objectIdentifier
        self.imagesIdentifiers = imagesIdentifiers
    }
    
}
