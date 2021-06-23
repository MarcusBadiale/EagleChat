//
//  ChatViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import MessageKit
import SDWebImage
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
        fetchConversations()
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
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.backgroundColor = #colorLiteral(red: 0.1529260874, green: 0.1529496312, blue: 0.1529181004, alpha: 1)
        messageInputBar.delegate = self
        
        setupInputButton()
    }
    
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 34, height: 34), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.3669571579, green: 0.2636830509, blue: 0.3215260208, alpha: 1)
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        
        messageInputBar.sendButton.setTitleColor(#colorLiteral(red: 0.3669571579, green: 0.2636830509, blue: 0.3215260208, alpha: 1), for: .normal)
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
            self?.presentPhotoInputActions()
        })
        
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default) { [weak self] _ in
            
        })
        
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default) { [weak self] _ in
            
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func presentPhotoInputActions() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach a photo from?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func fetchConversations() {
        let id = viewModel.conversationId
        guard !id.isEmpty else {
            return
        }
    
        DatabaseManager.shared.getAllMessagesForConversation(with: id) { [weak self] result in
            switch result {
            case let .success(conversations):
                guard !conversations.isEmpty else {
                    return
                }
                self?.viewModel.messages = conversations
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                }
                
            case let .failure(error):
                print("Falhpu em dar fetch nas mensagens: ", error)
            }
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let imageData = image.pngData(),
              let selfSender = viewModel.selfSender,
              let messageId = createMessageId() else {
            return
        }
        
        let fileName = "\(UUID().uuidString).png"
        
        // Upload image
        StorageManager.shared.updloadChatImage(with: imageData, filename: fileName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(urlString):
                print("Uploaded message photo")
                
                guard let url = URL(string: urlString),
                      let placeholder = UIImage(systemName: "plus") else {
                    return
                }
                
                let media = Media(url: url, image: nil, placeholderImage: placeholder, size: .zero)
                
                let message = Message(
                    sender: selfSender,
                    messageId: messageId,
                    sentDate: Date(),
                    kind: .photo(media)
                )
                
                DatabaseManager.shared.sendMessage(
                    to: self.viewModel.conversationId,
                    recipientName: self.viewModel.otherUserName,
                    otherUserEmail: self.viewModel.otherUserEmail,
                    newMessage: message
                ) { success in
                    if success {
                        print("sent photo message")
                    } else {
                        print("failed sent photo message")
                    }
                }
                
            case let .failure(error):
                print("Failed to upload message photo with error: ", error)
            }
        }
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
        let message = Message(
            sender: selfSender,
            messageId: messageId,
            sentDate: Date(),
            kind: .text(text)
        )
        
        inputBar.inputTextView.text = ""
        
        // Send Message
        if viewModel.isNewConversation {
            DatabaseManager.shared.createNewConversation(
                with: viewModel.otherUserEmail, name: self.title ?? "User",
                firstMessage: message
            ) { [weak self] success in
                self?.viewModel.isNewConversation = false
            }
        } else {
            // append to existing data
            DatabaseManager.shared.sendMessage(to: viewModel.conversationId, recipientName: viewModel.otherUserName, otherUserEmail: viewModel.otherUserEmail, newMessage: message) { success in
                if success {
                    print("message sent")
                    print(self.viewModel.selfSender)
                } else {
                    print("failed to send")
                }
            }
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
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        
        let fileName = sender.senderId + "_profile_picture.png"

        let path = "images/\(fileName)"

        if sender.senderId == currentSender().senderId {
            if let currentUserImage = self.viewModel.senderPhotoURL {
                avatarView.sd_setImage(with: currentUserImage, completed: nil)
            } else {
                StorageManager.shared.donwloadURL(for: path) { [weak self] result in
                    switch result {
                    case let .success(url):
                        self?.viewModel.senderPhotoURL = url
                        avatarView.sd_setImage(with: url, completed: nil)

                    case let .failure(error):
                        print("Failed to get download url: ", error)
                    }
                }
            }

        } else {
            if let otherUserImageUrl = self.viewModel.otherUserPhotoUrl {
                avatarView.sd_setImage(with: otherUserImageUrl, completed: nil)
            } else {
                StorageManager.shared.donwloadURL(for: path) { [weak self] result in
                    switch result {
                    case let .success(url):
                        self?.viewModel.otherUserPhotoUrl = url
                        avatarView.sd_setImage(with: url, completed: nil)

                    case let .failure(error):
                        print("Failed to get download url: ", error)
                    }
                }
            }
        }
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let messageSender = message.sender
        guard let selfSender = viewModel.selfSender else {
            fatalError()
        }
        
        return selfSender.senderId == messageSender.senderId ? #colorLiteral(red: 0.3669571579, green: 0.2636830509, blue: 0.3215260208, alpha: 1) : .lightGray
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        viewModel.messages.count
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        
        switch message.kind {
        case .photo(let media):
            guard let imageurl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageurl, completed: nil)
            
        default:
            break
        }
    }
}

extension ChatViewController: MessageCellDelegate {
    func didTapBackground(in cell: MessageCollectionViewCell) {
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        let message = viewModel.messages[indexPath.section]
        
        switch message.kind {
        case .photo(let media):
            guard let imageurl = media.url else {
                return
            }
            viewModel.goToPhotoViewer(imageUrl: imageurl)
            
        default:
            break
        }
    }
}
