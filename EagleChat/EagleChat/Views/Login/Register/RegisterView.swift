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
    
    //MARK: - Internal variables
    lazy var spinner = JGProgressHUD(style: .dark)
    
    lazy var logoImageView: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        view.backgroundColor = .white
        view.tintColor = .gray
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = K.buttonWidth / 2
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    lazy var firstNameTextField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.returnKeyType = .next
        view.backgroundColor = #colorLiteral(red: 0.3669571579, green: 0.2636830509, blue: 0.3215260208, alpha: 1)
        view.textColor = .white
        view.attributedPlaceholder = NSAttributedString(string: "First Name...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return view
    }()
    
    lazy var lastNameTextField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.returnKeyType = .next
        view.backgroundColor = #colorLiteral(red: 0.3669571579, green: 0.2636830509, blue: 0.3215260208, alpha: 1)
        view.textColor = .white
        view.attributedPlaceholder = NSAttributedString(string: "Last Name...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.keyboardType = .emailAddress
        view.returnKeyType = .next
        view.textColor = .white
        view.backgroundColor = #colorLiteral(red: 0.3669571579, green: 0.2636830509, blue: 0.3215260208, alpha: 1)
        view.attributedPlaceholder = NSAttributedString(string: "Email...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.borderStyle = .roundedRect
        view.returnKeyType = .done
        view.textColor = .white
        view.backgroundColor = #colorLiteral(red: 0.3669571579, green: 0.2636830509, blue: 0.3215260208, alpha: 1)
        view.attributedPlaceholder = NSAttributedString(string: "Senha...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return view
    }()
    
    lazy var RegisterButton: UIButton = {
        let view = UIButton()
        view.setTitle("Register", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        view.backgroundColor = #colorLiteral(red: 0.3669571579, green: 0.2636830509, blue: 0.3215260208, alpha: 1)
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
        backgroundColor = #colorLiteral(red: 0.1529260874, green: 0.1529496312, blue: 0.1529181004, alpha: 1)
        
        addSubviews([logoImageView, firstNameTextField,
                     lastNameTextField, emailTextField,
                     passwordTextField, RegisterButton], constraints: true)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            logoImageView.widthAnchor
                .constraint(equalToConstant: K.buttonWidth),
            logoImageView.heightAnchor
                .constraint(equalToConstant: K.buttonWidth),
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

extension RegisterView {
    enum K {
        static let buttonWidth:CGFloat = 100
    }
}
