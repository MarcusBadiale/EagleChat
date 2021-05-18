//
//  NewChatViewModel.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import Foundation

final class NewChatViewModel {
    
    // MARK: - Private variables
    private let coordinator: Coordinator
    
    // MARK: - Internal variables
    var users: [[String:String]] = []
    var filteredUsers: [[String:String]] = []
    var hasFetched = false
    
    // MARK: - Init
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

extension NewChatViewModel {
    
}
