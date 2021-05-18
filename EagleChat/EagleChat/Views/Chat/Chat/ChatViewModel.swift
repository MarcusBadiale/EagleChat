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
    
    let isNewConversation: Bool
    let otherUserEmail: String
    let otherUserName: String
    
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
        return Sender(photoURL: "",
                      senderId: email,
                      displayName: "Marcus")
    }
    
    var messages = [Message]()
    
    // MARK: - Init
    init(coordinator: Coordinator, user: [String:String], newConversation: Bool) {
        self.coordinator = coordinator
        
        otherUserEmail = user["email"] ?? ""
        otherUserName = user["name"] ?? ""
        isNewConversation = newConversation
    }
}

extension ChatViewModel {
}
