//
//  FirebaseObject.swift
//  IceHockey
//
//  Created by  Buxlan on 10/29/21.
//

import Foundation

protocol FirebaseObject {
    var objectIdentifier: String { get set }    
}

extension FirebaseObject {
    var isNew: Bool {
        return self.objectIdentifier.isEmpty
    }
}
