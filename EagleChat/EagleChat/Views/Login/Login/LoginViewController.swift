//
//  LoginViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

final class LoginViewController: BaseViewController<LoginView> {

    // MARK: - Private variables
    private let viewModel: LoginViewModel
    
    // MARK: - Init
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    private var loginGoogleObserver: NSObjectProtocol?
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        GIDSignIn.sharedInstance().presentingViewController = self
        
        loginGoogleObserver = NotificationCenter.default.addObserver(forName: .googleLogInNotification,
                                                                     object: nil,
                                                                     queue: .main) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    deinit {
        if let observer = loginGoogleObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension LoginViewController {
    
    // MARK: - Private methods
    private func setup() {
        title = "Login"
        addRegisterBtn()
        addTargets()
        addDelegates()
        customView.emailTextField.becomeFirstResponder()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func addRegisterBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegisterBtn))
    }
    
    func addTargets() {
        customView.loginButton.addTarget(self,
                                         action: #selector(didTapLoginButton),
                                         for: .touchUpInside)
    }
    
    func addDelegates() {
        customView.emailTextField.delegate = self
        customView.passwordTextField.delegate = self
    }
}

// MARK: - Actions
extension LoginViewController {
    @objc
    func didTapRegisterBtn() {
        viewModel.goToRegister()
    }
    
    @objc
    func didTapLoginButton() {
        guard let email = customView.emailTextField.text,
              let password = customView.passwordTextField.text else {
            return
        }
        
        customView.showSpinner()
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let authResult = result,
                  error == nil else {
                print("Erro ao logar com: ", email)
                return
            }
            
            let user = authResult.user
            self?.customView.hideSpinner()
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == customView.emailTextField {
            customView.passwordTextField.becomeFirstResponder()
        } else {
            didTapLoginButton()
        }
        
        return true
    }
}

extension Notification.Name {
    static let googleLogInNotification = Notification.Name("googleLogInNotification")
}