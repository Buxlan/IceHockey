//
//  LoginTextField.swift
//  IceHockey
//
//  Created by  Buxlan on 12/6/21.
//

import UIKit

class LoginTextField: UITextField {
     
    init() {
        super.init(frame: .zero)
        accessibilityIdentifier = "loginTextField"
        placeholder = L10n.Auth.usernamePlaceholder
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false
        keyboardAppearance = .dark
        keyboardType = .default
        backgroundColor = Colors.Gray.light
        font = Fonts.Regular.subhead
        layer.cornerRadius = 8
        clipsToBounds = true
        tintColor = Colors.Gray.dark
        let attr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: Colors.Gray.dark,
            NSAttributedString.Key.font: Fonts.Regular.subhead
        ]
        attributedPlaceholder = NSAttributedString(
            string: L10n.Auth.usernamePlaceholder,
            attributes: attr
        )
        self.setImage(Asset.person.image.withRenderingMode(.alwaysTemplate))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 40, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 40, dy: 10)
    }
    
}

extension LoginTextField {
    
    typealias DataType = TextFieldModel
    func configure(data: DataType) {
        placeholder = data.placeholderText
        backgroundColor = data.backgroundColor
        font = data.font
        tintColor = data.tintColor
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: data.tintColor,
            NSAttributedString.Key.font: data.font
        ]
        attributedPlaceholder = NSAttributedString(string: data.placeholderText,
                                                   attributes: attributes)
    }
}
