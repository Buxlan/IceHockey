//
//  EditEventPhotoCollectionCell.swift
//  IceHockey
//
//  Created by  Buxlan on 10/23/21.
//

import UIKit

class EditEventPhotoCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    typealias DataType = PhotoCellModel
    private var data: DataType?
    
    internal var isInterfaceConfigured: Bool = false
    let imageAspectRate: CGFloat = 1.77
    let actionButtonHeight: CGFloat = 24
        
    private lazy var dataImageView: UIImageView = {
        let cornerRadius: CGFloat = 32.0
        let view = UIImageView()
        view.accessibilityIdentifier = "dataImageView"
        view.backgroundColor = Asset.other3.color
        view.tintColor = Asset.other0.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cameraImage: UIImage = {
        return Asset.cameraViewfinder.image
            .resizeImage(to: 80, aspectRatio: .current)
            .withRenderingMode(.alwaysTemplate)
    }()
    
    private lazy var actionButton: UIButton = {
        let view = UIButton()
        view.accessibilityIdentifier = "actionButton (collection cell)"
        view.backgroundColor = Asset.other3.color
        view.setTitleColor(Asset.textColor.color, for: .normal)
        view.tintColor = Asset.other0.color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = actionButtonHeight / 2
        view.layer.borderColor = Asset.other0.color.cgColor
        view.layer.borderWidth = 0.5
        let image = Asset.xmark.image.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Lifecircle
    
    override func prepareForReuse() {
        dataImageView.image = nil
        isInterfaceConfigured = false
        data = nil
    }
        
    // MARK: - Helper functions
    
    func configureInterface() {
        if isInterfaceConfigured { return }
        tintColor = UIColor.black
        backgroundColor = Asset.other3.color
                
        contentView.addSubview(dataImageView)
        contentView.addSubview(actionButton)
        configureConstraints()
        
        actionButton.addTarget(self, action: #selector(deleteHandle), for: .touchUpInside)
        
        isInterfaceConfigured = true
    }
    
    internal func configureConstraints() {
        let constraints: [NSLayoutConstraint] = [
            
            dataImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dataImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dataImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -actionButtonHeight-4),
            dataImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -actionButtonHeight-4),
            
            actionButton.centerXAnchor.constraint(equalTo: dataImageView.trailingAnchor),
            actionButton.centerYAnchor.constraint(equalTo: dataImageView.topAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: actionButtonHeight),
            actionButton.heightAnchor.constraint(equalToConstant: actionButtonHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension EditEventPhotoCollectionCell: ConfigurableCollectionContent {
    
    func configure(with data: DataType) {
        configureInterface()
        self.data = data
        if let image = data.image {
            actionButton.isHidden = false
            self.dataImageView.image = image
            self.dataImageView.contentMode = .scaleAspectFill
        } else {
            actionButton.isHidden = true
            self.dataImageView.image = cameraImage
            self.dataImageView.contentMode = .center
        }
    }
    
}

extension EditEventPhotoCollectionCell {
    
    @objc private func deleteHandle() {
        data?.deleteAction()
    }
    
}
