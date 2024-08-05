//
//  ForgotViewController.swift
//  ToDoListTest
//
//  Created by Константин Евсюков on 04.08.2024.
//

import UIKit
import SnapKit

class ForgotViewController: UIViewController {
    
    private let forgotlabel = LabelType(type: .forgot)
    private let emailLabel = LabelType(type: .email)
    private let emailTextField = TextFieldtype(type: .email)
    private let logoImageView = UIImageView()
    private let resetButton = UIButton()
    private var errorLabel = UILabel()
    private var errorImage = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
}

//MARK: Setup UI
private extension ForgotViewController {
    
    func setupUI() {
        setupImage()
        setupButton()
        setupErrorLabel()
        addSubViews()
        makeConstraints()
    }
    
    func setupImage() {
        logoImageView.image = UIImage(named: "clothes")
        logoImageView.contentMode = .scaleToFill
        logoImageView.layer.cornerRadius = 20
        logoImageView.clipsToBounds = true
        
        errorImage.contentMode = .scaleToFill
    }
    
    func setupButton() {
        resetButton.backgroundColor = .green
        resetButton.layer.cornerRadius = 25
        resetButton.setTitle("Сброс пароля", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        resetButton.addTarget(self, action: #selector(resetButtonButtonTapped), for: .touchUpInside)
    }
    
    func setupErrorLabel() {
        errorLabel.text = ""
        errorLabel.textColor = .red
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.textAlignment = .center
    }
    
    func addSubViews() {
        [forgotlabel, logoImageView, emailLabel, emailTextField, errorLabel, errorImage, resetButton].forEach {
            view.addSubview($0)
        }
    }
    
    func makeConstraints() {
        forgotlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(90)
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(forgotlabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(500)
            make.left.equalToSuperview().inset(25)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(40)
        }
        
        errorImage.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(27)
            make.size.equalTo(20)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.equalTo(errorImage.snp.right).offset(5)
        }
        
        resetButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.left.equalToSuperview().inset(45)
            make.width.equalTo(304)
            make.height.equalTo(52)
        }
    }
    
    @objc func resetButtonButtonTapped() {
        animateButton(resetButton)
        
        let email = self.emailTextField.text ?? ""
        
        if !Validator.isValidEmail(for: email) {
            emailTextField.layer.borderColor = UIColor.red.cgColor
            
            errorImage.image = UIImage(named: "error")
            errorLabel.text  = "Неверный логин, Email или пароль"
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                return
            }
            
            AlertManager.showPasswordResetSent(on: self)
        }
    }
}
