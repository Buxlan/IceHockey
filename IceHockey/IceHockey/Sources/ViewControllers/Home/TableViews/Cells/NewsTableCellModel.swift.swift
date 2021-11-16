//
//  NewsTableCellModel.swift.swift
//  IceHockey
//
//  Created by  Buxlan on 11/4/21.
//

import UIKit

struct NewsTableCellModel: TableCellModel {
    
    var uid: String
    var title: String
    var description: String
    var imageID: String
    var type: String
    var author: String
    
    var date: String
    
    var backgroundColor: UIColor = Asset.other3.color
    var textColor: UIColor = Asset.textColor.color
    
    var typeBackgroundColor: UIColor
    var typeTextColor: UIColor
    var likesCount: Int = 0
    
    var likeAction: (Bool) -> Void = { _ in }
    var shareAction = {}
    
    init(data: SportNewsDatabaseFlowImpl) {
        uid = data.uid
        title = data.title
        description = data.text
        imageID = data.mainImageID ?? ""
        type = data.type.description
        author = data.author
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: data.date)
        date = dateString
        
        typeBackgroundColor = data.type.backgroundColor
        typeTextColor = data.type.textColor
    }
}
