//
//  ChatViewModel.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 21.08.2023.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [any Message] = []
    
    private let apiWorker = APIWorker()
    
    func sendMessage(message: String) async {
        // Save user's message
        let userMessage = MessageModel(role: .user, text: message)
        messages.append(userMessage)
        
        let messageLog = OpenAIDataMapper.map(messages: messages)
        guard let replyMessage = await apiWorker.send(messageLog: messageLog) else {
            return
        }
        
        // Save reply message
        messages.append(replyMessage)
    }
}
