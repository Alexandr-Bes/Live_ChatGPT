//
//  MessageModel.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 01.11.2023.
//

import Foundation

enum MessageUserType: String {
    case user
    case assistant
    case unknown
}

protocol Message: Identifiable {
    var id: String { get }
    var role: MessageUserType { get }
    var text: String { get }
    var date: Date? { get }
}

struct MessageModel: Message {
    let id: String = UUID().uuidString
    let role: MessageUserType
    let text: String
    let date: Date?
    
    init(role: MessageUserType, text: String, date: Date? = Date()) {
        self.role = role
        self.text = text
        self.date = date
    }
}
