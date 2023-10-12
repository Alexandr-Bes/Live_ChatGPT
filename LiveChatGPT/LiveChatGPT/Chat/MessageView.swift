//
//  MessageView.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 03.10.2023.
//

import SwiftUI

struct MessageView: View {
    var message: [String: String]
    
    var messageColor: Color {
        if message["role"] == "user" {
            return .blue
        } else if message["role"] == "assistant" {
            return .green
        } else {
            return .red
        }
    }
    
    var body: some View {
        if message["role"] != "system" {
            HStack {
                if message["role"] == "user" {
                    Spacer()
                }
                
                
                Text(message["content"] ?? "error")
                    .foregroundColor(.white)
                    .padding()
                    .background(messageColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 1)
                
                if message["role"] == "assistant" {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MessageView(message: ["role": "assistant", "content": "Hello world"])
}
