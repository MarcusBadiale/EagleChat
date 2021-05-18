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
        customView.logoImageView.addTarget(self,
                                           action: #selector(didTapImageView),
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
    func didTapImageView() {
        presentPhotoActionSheet()
    }
    
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
                
                let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, email: email)
                
                DatabaseManager.shared.insertUser(
                    with: chatUser
                ) { success in
                    if success {
                        // upload image
                        guard let image = self?.customView.logoImageView.backgroundImage(for: .normal),
                              let data = image.pngData() else {
                            return
                        }
                        let fileName = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(
                            with: data,
                            filename: fileName
                        ) { result in
                            switch result {
                            case let .success(urlString):
                                UserDefaults.standard.set(urlString, forKey: "profile_picture_url")
                                print(urlString)
                                
                            case let .failure(error):
                                print(error)
                            }
                        }
                        
                    }
                }
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

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.presentCamera()
        })
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default) { [weak self] _ in
            self?.presentPhotoPicker()
        })
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.customView.logoImageView.setBackgroundImage(image, for: .normal)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
