//
//  ProfileViewModel.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import Foundation

final class ProfileViewModel {
    var data = ["Log Out"]
    
    // MARK: - Private variables
    private let coordinator: Coordinator
    
    // MARK: - Init
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

extension ProfileViewModel {
    func goToLogin() {
        coordinator.routeToLogin()
    }
}
