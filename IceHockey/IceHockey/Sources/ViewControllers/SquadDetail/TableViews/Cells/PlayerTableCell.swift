//
//  PlayerTableCell.swift
//  IceHockey
//
//  Created by  Buxlan on 10/28/21.
//

import UIKit

class PlayerTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    typealias DataType = SportPlayer
    
    var isInterfaceConfigured = false
    var imageAspectRate: CGFloat = 1
    let imageHeight: CGFloat = 40
    
    private var placeholderImage: UIImage = Asset.camera.image
    private var noImage: UIImage = Asset.noImage256.image
        
    // MARK: - Lifecircle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        isInterfaceConfigured = false
    }
    
    // MARK: - Helper functions
    
    func configureUI() {
        if isInterfaceConfigured { return }
        contentView.backgroundColor = Asset.other3.color
        tintColor = Asset.textColor.color
        textLabel?.textColor = tintColor
        configureConstraints()
        isInterfaceConfigured = true
    }
    
    internal func configureConstraints() {
        let constraints: [NSLayoutConstraint] = [
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension PlayerTableCell: ConfigurableCell {
    
    func configure(with data: DataType) {
        configureUI()        
        self.textLabel?.text = data.displayName
    }
    
}
