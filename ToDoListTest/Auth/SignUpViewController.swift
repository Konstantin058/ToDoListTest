//
//  SignUpViewController.swift
//  ToDoListTest
//
//  Created by Константин Евсюков on 03.08.2024.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
    
    private var signUp = LabelType(type: .signUp)
    private var loginLable = LabelType(type: .login)
    private var emailLabel = LabelType(type: .email)
    private var passwordLabel = LabelType(type: .password)
    private var errorLabel = UILabel()
    private var errorImage = UIImageView()
    
    private var loginTextField = TextFieldtype(type: .login)
    private var emailTextField = TextFieldtype(type: .email)
    private var passwordTextField = TextFieldtype(type: .password)
    
    private let signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
}

//MARK: Setup UI
private extension SignUpViewController {
    
    func setupUI() {
        setupNavbarItem()
        setupButton()
        setupBackButton()
        setupEroorImage()
        setupErrorLabel()
        textFieldDelegate()
        addSubviews()
        makeConstraints()
    }
    
    func setupNavbarItem() {
        self.navigationItem.title = ""
    }
    
    func setupButton() {
        signUpButton.backgroundColor = .green
        signUpButton.layer.cornerRadius = 25
        signUpButton.setTitle("Регистрация", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setupEroorImage() {
        errorImage.contentMode = .scaleToFill
    }
    
    func setupErrorLabel() {
        errorLabel.text = ""
        errorLabel.textColor = .red
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.textAlignment = .center
    }
    
    func textFieldDelegate() {
        loginTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func addSubviews() {
        [signUp, loginLable, loginTextField, emailLabel, emailTextField, passwordLabel, passwordTextField, errorImage, errorLabel, signUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    func makeConstraints() {
        signUp.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(90)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        loginLable.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(250)
            make.left.equalToSuperview().inset(25)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLable.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(40)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(25)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(40)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(25)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(720)
            make.left.equalToSuperview().inset(45)
            make.width.equalTo(304)
            make.height.equalTo(52)
        }
        
        errorImage.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(27)
            make.size.equalTo(20)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.left.equalTo(errorImage.snp.right).offset(5)
        }
    }
    
    @objc func signUpTapped(sender: UIButton) {
        animateButton(signUpButton)
        
        let registerUserRequest = RegisterUserRequest(login: self.loginTextField.text ?? "",
                                                      email: self.emailTextField.text ?? "",
                                                      password: self.passwordTextField.text ?? "")
        
        if !Validator.isValidUsername(for: registerUserRequest.login) 
            || !Validator.isValidEmail(for: registerUserRequest.email)
            || !Validator.isPasswordValid(for: registerUserRequest.password) {
            loginTextField.layer.borderColor = UIColor.red.cgColor
            emailTextField.layer.borderColor = UIColor.red.cgColor
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            
            errorImage.image = UIImage(named: "error")
            errorLabel.text  = "Неверный логин, Email или пароль"
            return
        }
        
        AuthService.shared.registreUser(with: registerUserRequest) { [weak self] wasRegistred, error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showRegistrationErrorAlert(on: self, with: error)
                return
            }
            
            if wasRegistred {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            } else {
                AlertManager.showRegistrationErrorAlert(on: self)
            }
        }
        
        let entanceVC = SignInViewController()
        navigationController?.pushViewController(entanceVC, animated: true)
    }
}

//MARK: UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.text = ""
        errorImage.image = nil
        
        if textField == loginTextField {
            loginTextField.layer.borderColor = UIColor.green.cgColor
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passwordTextField.layer.borderColor = UIColor.black.cgColor
        } else if textField == emailTextField {
            loginTextField.layer.borderColor = UIColor.black.cgColor
            emailTextField.layer.borderColor = UIColor.green.cgColor
            passwordTextField.layer.borderColor = UIColor.black.cgColor
        } else {
            loginTextField.layer.borderColor = UIColor.black.cgColor
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passwordTextField.layer.borderColor = UIColor.green.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorLabel.text = ""
        errorImage.image = nil
        
        if textField == loginTextField {
            loginTextField.layer.borderColor = UIColor.green.cgColor
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passwordTextField.layer.borderColor = UIColor.black.cgColor
        } else if textField == emailTextField {
            loginTextField.layer.borderColor = UIColor.black.cgColor
            emailTextField.layer.borderColor = UIColor.green.cgColor
            passwordTextField.layer.borderColor = UIColor.black.cgColor
        } else {
            loginTextField.layer.borderColor = UIColor.black.cgColor
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passwordTextField.layer.borderColor = UIColor.green.cgColor
        }
        return true
    }
}

