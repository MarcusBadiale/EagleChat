//
//  LoginViewModel.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import Foundation

final class LoginViewModel {
    
    // MARK: - Private variables
    private let coordinator: Coordinator
    
    // MARK: - Init
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Functions
extension LoginViewModel {
    func goToRegister() {
        coordinator.routeToRegister()
    }
}
