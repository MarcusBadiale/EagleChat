//
//  ChatViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {

    // MARK: - Private variables
    private let viewModel: ChatViewModel
    
    // MARK: - Init
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
}

extension ChatViewController {
    
    // MARK: - Private methods
    private func setup() {
        title = viewModel.otherUserName
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = viewModel.selfSender,
              let messageId = createMessageId() else {
            return
        }
        
        print("Sending: ", text)
        
        // Send Message
        if viewModel.isNewConversation {
            let message = Message(
                sender: selfSender,
                messageId: messageId,
                sentDate: Date(),
                kind: .text(text))
            
            DatabaseManager.shared.createNewConversation(
                with: viewModel.otherUserEmail,
                firstMessage: message
            ) { [weak self] success in
                print(success)
            }
        } else {
            // append to existing data
        }
    }
    
    private func createMessageId() -> String? {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.shared.safeEmail(emailAddress: currentUserEmail)
        let dateString: String = viewModel.dateFormatter.string(from: Date())
        
        let newId = "\(viewModel.otherUserEmail)_\(safeEmail)_\(dateString)"
        
        print("Created message id: ", newId)
        
        return newId
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = viewModel.selfSender {
            return sender
        }
        fatalError("Self Sender is nil, email should be cached")
        return Sender(photoURL: "", senderId: "12", displayName: "DummySender")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        viewModel.messages.count
    }
}
