//
//  ViewController.swift
//  SignInFormSwiftRx
//
//  Created by Jakub Gawecki on 28/11/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    // MARK: - UI
    fileprivate lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.purple.cgColor
        textField.autocorrectionType = .no
        textField.placeholder = "Enter username"
        textField.returnKeyType = .continue
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    fileprivate lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.purple.cgColor
        textField.autocorrectionType = .no
        textField.placeholder = "Enter username"
        textField.returnKeyType = .continue
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    fileprivate lazy var loginButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.cornerStyle = .capsule
        config.title = "Login"
        config.baseBackgroundColor = .purple
        config.baseForegroundColor = .white
        
        config.image = UIImage(systemName: "wallet.pass")
        config.buttonSize = .large
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Property
    let viewModel = ViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
        usernameTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.usernamePublisher).disposed(by: disposeBag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.passwordPublisher).disposed(by: disposeBag)
        
        viewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    fileprivate func layoutUI() {
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalToConstant: 330),
            usernameTextField.heightAnchor.constraint(equalToConstant: 55),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 330),
            passwordTextField.heightAnchor.constraint(equalToConstant: 55),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


}

