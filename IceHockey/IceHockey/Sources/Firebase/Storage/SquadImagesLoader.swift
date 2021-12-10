//
//  SquadImagesLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/22/21.
//

import Firebase

class SquadImagesLoader: FirebaseImagesLoader {
    
    internal var objectIdentifier: String
    internal lazy var imagesPath: String = "squads/\(objectIdentifier)"
    internal var handlers: [String: (UIImage?) -> Void] = [:]
    internal var imagesIdentifiers: [String]
    
    required init(objectIdentifier: String,
                  imagesIdentifiers: [String]) {
        self.objectIdentifier = objectIdentifier
        self.imagesIdentifiers = imagesIdentifiers
    }
    
}
