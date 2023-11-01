//
//  MessageView.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 03.10.2023.
//

import SwiftUI

struct MessageView: View {
//    var message: [String: String]
    var message: any Message
    
    var messageColor: Color {
        switch message.role {
        case .user:
            return .blue
        case .assistant:
            return .green
        case .unknown:
            return .red
        }
//        if message["role"] == "user" {
//            return .blue
//        } else if message["role"] == "assistant" {
//            return .green
//        } else {
//            return .red
//        }
    }
    
    var body: some View {
//        if message["role"] != "system" {
            HStack {
                if message.role == .user {
                    Spacer()
                }
                
                Text(message.text)
                    .foregroundColor(.white)
                    .padding()
                    .background(messageColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 1)
                
                if message.role != .user {
                    Spacer()
                }
            }
//        }
    }
}

#Preview {
    MessageView(message: MessageModel(role: .unknown, text: "Error")) //["role": "assistant", "content": "Hello world"])
}
