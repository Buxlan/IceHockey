//
//  ShareButton.swift
//  IceHockey
//
//  Created by  Buxlan on 11/7/21.
//

import UIKit

class ShareButton: UIButton {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.accessibilityIdentifier = "shareButton"
        let image = Asset.share.image
            .resizeImage(to: 32, aspectRatio: .current)
            .withRenderingMode(.alwaysTemplate)
        self.contentMode = .scaleAspectFit
        self.imageView?.contentMode = .scaleAspectFit
        self.setImage(image, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.contentEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
