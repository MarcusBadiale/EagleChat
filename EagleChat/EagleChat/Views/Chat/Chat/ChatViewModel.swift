//
//  ChatViewModel.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import Foundation
import FirebaseAuth

final class ChatViewModel {
    
    // MARK: - Private variables
    private let coordinator: Coordinator
    
    var isNewConversation: Bool
    let otherUserEmail: String
    let otherUserName: String
    
    var otherUserPhotoUrl: URL?
    var senderPhotoURL: URL?
    
    let conversationId: String
    
    public var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }
    
    //This will come from firebase
    var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.shared.safeEmail(emailAddress: email)
        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: "Me")
    }
    
    var messages = [Message]()
    
    
    // MARK: - Init
    init(coordinator: Coordinator, chatId: String, userName: String, userEmail: String, newConversation: Bool) {
        self.coordinator = coordinator
        
        otherUserEmail = userEmail
        otherUserName = userName
        isNewConversation = newConversation
        conversationId = chatId
    }
}

extension ChatViewModel {
    func goToPhotoViewer(imageUrl: URL) {
        coordinator.routeToPhotoViwer(imageUrl: imageUrl)
    }
}
