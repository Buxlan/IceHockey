//
//  EventDetailUsefulButtonsCellModel.swift
//  IceHockey
//
//  Created by  Buxlan on 11/12/21.
//

import UIKit

struct EventDetailUsefulButtonsCellModel: TableCellModel {
    
    // MARK: - Properties
    var eventID: String
    var likesCount: Int = 0
    var viewsCount: Int = 0
    var tintColor: UIColor = Asset.other0.color
    var textColor: UIColor = Asset.textColor.color
    var selectedViewTintColor: UIColor = Asset.accent0.color
    var backgroundColor: UIColor = Asset.other3.color
    var font: UIFont = .regularFont16
    
    // MARK: - Actions
    
    var likeAction: (Bool) -> Void = { _ in }
    var shareAction = {}
    
    // MARK: - Lifecircle
    
    init(_ data: SportEvent) {
        self.eventID = data.uid
    }
    
}
