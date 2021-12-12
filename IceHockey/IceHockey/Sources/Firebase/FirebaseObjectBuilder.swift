//
//  FirebaseObjectBuilder.swift
//  IceHockey
//
//  Created by  Buxlan on 12/1/21.
//

protocol FirebaseObjectBuilder {
//    associatedtype DataType
    init(objectIdentifier: String)
    func build(completionHandler: @escaping () -> Void)    
//    func getResult() -> DataType
}
