//
//  Conversation.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 26/05/21.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
