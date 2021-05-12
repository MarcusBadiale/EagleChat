//
//  LoginView.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import GoogleSignIn
import JGProgressHUD

final class LoginView: UIView {
    
    // MARK: - Private variables
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "LogoPlaceholder")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    //MARK: - Internal variables
    lazy var spinner = JGProgressHUD(style: .dark)
    
    lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Email..."
        view.borderStyle = .roundedRect
        view.keyboardType = .emailAddress
        view.returnKeyType = .next
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Senha..."
        view.isSecureTextEntry = true
        view.borderStyle = .roundedRect
        view.returnKeyType = .done
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let view = UIButton()
        view.setTitle("Log in", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        view.backgroundColor = .link
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var googleSignInButton = GIDSignInButton()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupLayout()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {
    
    //MARK: - Internal methods
    func showSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.spinner.show(in: self)
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.dismiss()
        }
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        backgroundColor = .white
        
        addSubviews([logoImageView, emailTextField,
                     passwordTextField, loginButton, googleSignInButton], constraints: true)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            logoImageView.widthAnchor
                .constraint(equalToConstant: 100),
            logoImageView.heightAnchor
                .constraint(equalToConstant: 100),
            logoImageView.centerXAnchor
                .constraint(equalTo: centerXAnchor),
            
            emailTextField.topAnchor
                .constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor
                .constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            loginButton.topAnchor
                .constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginButton.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            googleSignInButton.topAnchor
                .constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            googleSignInButton.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            googleSignInButton.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}
