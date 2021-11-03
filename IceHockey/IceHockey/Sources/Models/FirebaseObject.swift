//
//  FirebaseObject.swift
//  IceHockey
//
//  Created by  Buxlan on 10/29/21.
//

import Foundation

protocol FirebaseObject {
    var uid: String { get set }
    init?(key: String, dict: NSDictionary)
    static func getObject(by uid: String, completion handler: @escaping (Self?) -> Void)
    func save() throws
    func delete() throws
}
