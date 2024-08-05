//
//  CustomLabel.swift
//  ToDoListTest
//
//  Created by Константин Евсюков on 03.08.2024.
//

import UIKit

enum Label {
    case signIn
    case signUp
    case forgot
    case login
    case email
    case password
    case userLogin
}

class LabelType: UILabel {
    
    private let type: Label
    
    init(type: Label) {
        self.type = type
        super.init(frame: .zero)
        
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Setup UI
private extension LabelType {
    
    func setupLabel() {
        switch type {
        case .login:
            text = "Логин"
            textAlignment = .left
            font = .systemFont(ofSize: 18)
            textColor = .black
        case .email:
            text = "Email"
            textAlignment = .left
            font = .systemFont(ofSize: 18)
            textColor = .black
        case .password:
            text = "Пароль"
            textAlignment = .left
            font = .systemFont(ofSize: 18)
            textColor = .black
        case .signIn:
            text = "Вход"
            textAlignment = .center
            font = .systemFont(ofSize: 24, weight: .black)
            textColor = .black
        case .signUp:
            text = "Регистрация"
            textAlignment = .center
            font = .systemFont(ofSize: 24, weight: .black)
            textColor = .black
        case .forgot:
            text = "Сброс пароля"
            textAlignment = .center
            font = .systemFont(ofSize: 24, weight: .black)
            textColor = .black
        case .userLogin:
            textAlignment = .left
            font = .systemFont(ofSize: 10, weight: .black)
            textColor = .black
        }
    }
}
