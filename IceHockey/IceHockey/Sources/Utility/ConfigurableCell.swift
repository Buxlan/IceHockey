//
//  ConfigurableCell.swift
//  IceHockey
//
//  Created by  Buxlan on 9/13/21.
//

import UIKit

protocol ConfigurableEventCell {
    static var reuseIdentifier: String { get }
    func configure(with data: SportEvent)
    var isInterfaceConfigured: Bool { get set }
}
extension ConfigurableEventCell {
    static var reuseIdentifier: String { String(describing: Self.self) }
}

protocol ConfigurableTeamCell {
    static var reuseIdentifier: String { get }
    func configure(with data: SportTeam)
    var isInterfaceConfigured: Bool { get set }
}
extension ConfigurableTeamCell {
    static var reuseIdentifier: String { String(describing: Self.self) }
}

protocol ConfigurableCell {
    static var reuseIdentifier: String { get }
    var isInterfaceConfigured: Bool { get set }
        
    associatedtype DataType
    func configure(with data: DataType)
}
extension ConfigurableCell {
    static var reuseIdentifier: String { String(describing: Self.self) }
}

protocol ConfigurableActionCell {
    static var reuseIdentifier: String { get }    
    var isInterfaceConfigured: Bool { get set }
        
    associatedtype DataType
    associatedtype HandlerType
    func configure(with data: DataType, handler: HandlerType)
}
extension ConfigurableActionCell {
    static var reuseIdentifier: String { String(describing: Self.self) }
}

protocol SizeableConfigurableCell {
    static var reuseIdentifier: String { get }
    var isInterfaceConfigured: Bool { get set }
        
    associatedtype DataType where DataType: Sizeable
    func configure(with data: DataType)
}
extension SizeableConfigurableCell {
    static var reuseIdentifier: String { String(describing: Self.self) }
}

protocol CollectionViewDelegate: class {
    var delegate: UICollectionViewDelegate? { get set }
}

protocol CollectionViewDataSource: class {
    var dataSource: UICollectionViewDataSource? { get set }
}