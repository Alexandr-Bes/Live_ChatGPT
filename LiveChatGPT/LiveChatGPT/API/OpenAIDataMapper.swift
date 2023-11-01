//
//  OpenAIDataMapper.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 01.11.2023.
//

import Foundation

struct OpenAIDataMapper {
    static func map(messages: [any Message]) -> MessageLog {
        return messages.map { ["role": $0.role.rawValue, "content": $0.text] }
    }
    
    static func map(response: OpenAIResponse) -> (any Message)? {
        guard let message = response.choices.first?.message["content"],
              let unixDate = response.created
        else {
            return nil
        }
        return MessageModel(role: .assistant,
                            text: message,
                            date: Date(timeIntervalSince1970: TimeInterval(unixDate))
                            )
    }
}
