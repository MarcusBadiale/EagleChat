//
//  ConversationViewModel.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import Foundation
import FirebaseAuth

final class ConversationViewModel {
    
    // MARK: - Private variables
    private let coordinator: Coordinator
    
    // MARK: - Init
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

extension ConversationViewModel {
    func validadeAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            coordinator.routeToLogin()
        }
    }
    
    func goToChat(user: [String:String], isNewConversation: Bool) {
        coordinator.routeToChat(user: user, isNewConversation: isNewConversation)
    }
    
    func goToNewChat() {
        coordinator.routeToNewChat(delegate: self)
    }
    
    func goToProfile() {
        coordinator.routeToProfile()
    }
}

extension ConversationViewModel: NewChatDelegate {
    func completion(result: [String : String]) {
        print("\(result)")
        goToChat(user: result, isNewConversation: true)
    }
}
