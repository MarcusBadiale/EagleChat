//
//  DatabaseManager+Chat.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 18/05/21.
//

import Foundation
import FirebaseDatabase

//MARK: - Chat Manager
extension DatabaseManager {
    /// Creates a new conversation with target user email and first massage sent
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
            return
        }
        
        let safeEmail = safeEmail(emailAddress: currentEmail)
        let ref = database.child("\(safeEmail)")
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String: Any],
                  let dateString = self?.dateFormatter.string(from: firstMessage.sentDate) else {
                completion(false)
                print("user not found")
                return
            }
            
            var message = ""
            
            switch firstMessage.kind {
            case .text(let messageText):
                message = messageText
            default:
                break
            }
            
            let conversationID = "conversation_\(firstMessage.messageId)"
            
            let newConversationData: [String: Any] = [
                "id": conversationID,
                "other_user_email": otherUserEmail,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            let recipiente_newConversationData: [String: Any] = [
                "id": conversationID,
                "other_user_email": safeEmail,
                "name": currentName,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            //Update recipient conversation entry
            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { snapshot in
                if var conversations = snapshot.value as? [[String: Any]] {
                    // Append
                    conversations.append(recipiente_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversations)
                } else {
                    // create
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipiente_newConversationData])
                }
            }
                    
            // Update current user conversation
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                // Conversation array exists for curren user
                // Shoud append
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                
                ref.setValue(userNode) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationID,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                }
            } else {
                // new conversation
                userNode["conversations"] = [
                    newConversationData
                ]
                
                ref.setValue(userNode) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationID,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                }
            }
        }
    }
    
    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        let safeEmail = safeEmail(emailAddress: currentEmail)
        let dateString = dateFormatter.string(from: firstMessage.sentDate)
        
        var message = ""
        switch firstMessage.kind {
        case .text(let messageText):
            message = messageText
        default:
            break
        }
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": safeEmail,
            "is_read": false,
            "name": name
        ]
        
        let value: [String:Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        
        database.child("\(conversationID)").setValue(value) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
        }
        completion(true)
    }
    
    /// Fetches and returns all conversations for the user with passed in email
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>)-> Void) {
        database.child("\(email)/conversations").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let conversations: [Conversation] = value.map(Conversation.init)
            
            completion(.success(conversations))
        }
    }
    
    /// Gets all messages for a given conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>)-> Void) {
        database.child("\(id)/messages").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let messages: [Message] = value.compactMap { dictionary in
                guard let name = dictionary["name"] as? String,
                      let isRead = dictionary["is_read"] as? Bool,
                      let messageId = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let senderEmail = dictionary["sender_email"] as? String,
                      let type = dictionary["type"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let date = self.dateFormatter.date(from: dateString) else {
                    return nil
                }
                
                let sender = Sender(
                    photoURL: "",
                    senderId: senderEmail,
                    displayName: name
                )
                
                var media: Media?
                if let imageUrl = URL(string: content),
                   let placeHolder = UIImage(systemName: "plus") {
                    media = Media(url: imageUrl, image: nil,
                                  placeholderImage: placeHolder,
                                  size: CGSize(width: 300, height: 300))
                }
                
                return Message(
                    sender: sender,
                    messageId: messageId,
                    sentDate: date,
                    kind:  type == "text" ? .text(content) : .photo(media!)
                )
            }
            
            completion(.success(messages))
        }
    }
    
    /// Sends a message with target conversation and message
    public func sendMessage(to idForConversation : String, recipientName: String, otherUserEmail: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        database.child("\(idForConversation )/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var currentMessages = snapshot.value as? [[String: Any]],
                  let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                return
            }
            
            let currentUserSafeEmail = (self?.safeEmail(emailAddress: currentEmail))!
            let otherUserSafeEmail = (self?.safeEmail(emailAddress: otherUserEmail))!
            let dateString = (self?.dateFormatter.string(from: newMessage.sentDate))!
//            "Jul 7, 2021 at 6:48:58 PM GMT-3"
            
            var message = ""
            switch newMessage.kind {
            case .text(let messageText):
                message = messageText
            
            case .photo(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    message = targetUrlString
                }
                
            default:
                break
            }
            
            let collectionMessage: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_email": currentUserSafeEmail,
                "is_read": false,
                "name": recipientName
            ]
            
            currentMessages.append(collectionMessage)
            
            self?.database.child("\(idForConversation)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                self?.database.child("\(currentUserSafeEmail)/conversations").observeSingleEvent(of: .value) { snapshot in
                    guard var currentUserConversations = snapshot.value as? [[String: Any]] else {
                        completion(false)
                        return
                    }
                    
                    for (index, conversation) in currentUserConversations.enumerated() {
                        if let conversationId = conversation["id"] as? String, conversationId == idForConversation {
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message": message
                            ]
                            currentUserConversations[index]["latest_message"] = updatedValue
                            self?.database.child("\(currentUserSafeEmail)/conversations").setValue(currentUserConversations) { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }
                                
                                completion(true)
                                
                                self?.database.child("\(otherUserSafeEmail)/conversations").observeSingleEvent(of: .value) { snapshot in
                                    guard var otherUserConversations = snapshot.value as? [[String: Any]] else {
                                        completion(false)
                                        return
                                    }

                                    for (index, conversation) in otherUserConversations.enumerated() {
                                        if let conversationId = conversation["id"] as? String, conversationId == idForConversation {
                                            let updatedValue: [String: Any] = [
                                                "date": dateString,
                                                "is_read": false,
                                                "message": message
                                            ]
                                            otherUserConversations[index]["latest_message"] = updatedValue
                                            self?.database.child("\(otherUserSafeEmail)/conversations").setValue(otherUserConversations) { error, _ in
                                                guard error == nil else {
                                                    completion(false)
                                                    return
                                                }
                                                completion(true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Conversation {
    init(_ dictionaty: [String: Any]) {
        let latestMessageDic = dictionaty["latest_message"] as? [String: Any] ?? [:]
        self.init(
            id: dictionaty["id"] as? String ?? "",
            name: dictionaty["name"] as? String ?? "",
            otherUserEmail: dictionaty["other_user_email"] as? String ?? "",
            latestMessage: LatestMessage(latestMessageDic)
        )
    }
}

extension LatestMessage {
    init(_ dictionaty: [String: Any]) {
        self.init(
            date: dictionaty["date"] as? String ?? "",
            text: dictionaty["message"] as? String ?? "",
            isRead: dictionaty["is_read"] as? Bool ?? false
        )
    }
}
