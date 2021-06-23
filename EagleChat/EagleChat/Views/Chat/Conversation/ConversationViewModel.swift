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
    
    var conversations: [Conversation] = []
    
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
    
    func goToChat(chatId: String, userName: String, userEmail: String, isNewConversation: Bool) {
        coordinator.routeToChat(chatId: chatId,
                                userName: userName, userEmail: userEmail,
                                isNewConversation: isNewConversation)
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
        guard let userName = result["name"],
              let email = result["email"] else {
            return
        }
        goToChat(chatId: "", userName: userName, userEmail: email, isNewConversation: true)
    }
}
