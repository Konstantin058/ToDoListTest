//
//  CustomTextField.swift
//  ToDoListTest
//
//  Created by Константин Евсюков on 03.08.2024.
//

import UIKit

enum TextField: String {
    case login = "Логин"
    case email = " Email"
    case password = "Пароль"
}

class TextFieldtype: UITextField {
    
    private let type: TextField
    
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 15,
        bottom: 10,
        right: 10
    )
    
    init(type: TextField) {
        self.type = type
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}

//MARK: Setup UI
private extension TextFieldtype {
    
    func setupUI() {
        placeholder = type.rawValue
        clearButtonMode = .whileEditing
        backgroundColor = .clear
        textColor = .black
        font = .boldSystemFont(ofSize: 18)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
        returnKeyType = .next
        autocapitalizationType = .none
        
        switch type {
        case .login:
            keyboardType = .default
            tag = 0
        case .email:
            keyboardType = .emailAddress
            tag = 1
        case .password:
            keyboardType = .default
            returnKeyType = .done
            tag = 2
        }
    }
}

