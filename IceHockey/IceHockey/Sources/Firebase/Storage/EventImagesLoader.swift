//
//  EventImagesLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/17/21.
//

import UIKit

class EventImagesLoader: FirebaseImagesLoader {    
    
    internal var objectIdentifier: String
    internal lazy var imagesPath: String = "events/\(objectIdentifier)"
    internal var handlers: [String: (UIImage?) -> Void] = [:]
    internal var imagesIdentifiers: [String]
    
    required init(objectIdentifier: String,
                  imagesIdentifiers: [String]) {
        self.objectIdentifier = objectIdentifier
        self.imagesIdentifiers = imagesIdentifiers
    }
    
}
