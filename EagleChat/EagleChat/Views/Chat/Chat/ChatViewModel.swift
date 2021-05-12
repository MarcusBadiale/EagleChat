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
    
    //This will come from firebase
    let selfSender = Sender(photoURL: "",
                            senderId: "1",
                            displayName: "Marcus")
    var messages = [Message]()
    
    // MARK: - Init
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello world")))
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello world 2")))
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello world Hello world Hello world 3")))
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("He")))
    }
}

extension ChatViewModel {
}
