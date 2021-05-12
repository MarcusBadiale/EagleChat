//
//  RegisterView.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import JGProgressHUD

final class RegisterView: UIView {
    
    // MARK: - Private variables
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "LogoPlaceholder")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    //MARK: - Internal variables
    lazy var spinner = JGProgressHUD(style: .dark)
    
    lazy var firstNameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "First Name..."
        view.borderStyle = .roundedRect
        view.returnKeyType = .next
        return view
    }()
    
    lazy var lastNameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Last Name..."
        view.borderStyle = .roundedRect
        view.returnKeyType = .next
        return view
    }()
    
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
    
    lazy var RegisterButton: UIButton = {
        let view = UIButton()
        view.setTitle("Register", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        view.backgroundColor = .link
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
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

extension RegisterView {
    
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
        
        addSubviews([logoImageView, firstNameTextField,
                     lastNameTextField, emailTextField,
                     passwordTextField, RegisterButton], constraints: true)
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
            
            firstNameTextField.topAnchor
                .constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            firstNameTextField.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            firstNameTextField.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            lastNameTextField.topAnchor
                .constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            lastNameTextField.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            lastNameTextField.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor
                .constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20),
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
            
            RegisterButton.topAnchor
                .constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            RegisterButton.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            RegisterButton.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}
