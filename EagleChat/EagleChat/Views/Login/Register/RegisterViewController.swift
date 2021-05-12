//
//  RegisterViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import FirebaseAuth

final class RegisterViewController: BaseViewController<RegisterView> {

    // MARK: - Private variables
    private let viewModel: RegisterViewModel
    
    // MARK: - Init
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension RegisterViewController {
    
    // MARK: - Private methods
    private func setup() {
        title = "Register"
        addTargets()
        addDelegates()
    }
    
    func addTargets() {
        customView.RegisterButton.addTarget(self,
                                         action: #selector(didTapRegisterButton),
                                         for: .touchUpInside)
    }
    
    func addDelegates() {
        customView.emailTextField.delegate = self
        customView.passwordTextField.delegate = self
    }
}

// MARK: - Actions
extension RegisterViewController {
    @objc
    func didTapRegisterButton() {
        guard let email = customView.emailTextField.text,
              let firstName = customView.firstNameTextField.text,
              let lastName = customView.lastNameTextField.text,
              let password = customView.passwordTextField.text else {
            return
        }
        
        customView.showSpinner()
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let authResult = result,
                  error == nil else {
                print("Error creating user")
                return
            }
            
            let user = authResult.user
            print("logou com:", user)
            
            DatabaseManager.shared.userExists(with: email) { exists in
                if exists {
                    // Email ja existe
                    print("Email ja existe")
                    return
                }
                
                self?.customView.hideSpinner()
                
                DatabaseManager.shared.insertUser(with: .init(firstName: firstName,
                                                              lastName: lastName,
                                                              email: email))
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc
    func didTapChangeImage(_ sender: UITapGestureRecognizer? = nil) {
        print("change image")
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case customView.firstNameTextField:
            customView.lastNameTextField.becomeFirstResponder()
            
        case customView.lastNameTextField:
            customView.emailTextField.becomeFirstResponder()
            
        case customView.emailTextField:
            customView.passwordTextField.becomeFirstResponder()
            
        default:
            didTapRegisterButton()
        }
        
        return true
    }
}


