//
//  ChatBottomView.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 12.10.2023.
//

import SwiftUI

struct ChatBottomView: View {
    @State private var text: String = ""
    
    @FocusState var isFocused: Bool
    
    var sendAction: ((String) -> Void)?
    var textFieldAction: (() -> Void)?
    var pickImageAction: (() -> Void)?
    
    init(isFocused: FocusState<Bool>, 
         sendAction: ((String) -> Void)? = nil,
         textFieldAction: (() -> Void)? = nil,
         pickImageAction: (() -> Void)? = nil) {
        self._isFocused = isFocused
        self.textFieldAction = textFieldAction
        self.sendAction = sendAction
        self.pickImageAction = pickImageAction
    }
    
    var body: some View {
        HStack {
            Button {
                pickImageAction?()
            } label: {
                Image(systemName: "paperclip")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.white)
            }
            
            TextField("Type your question", text: $text)
                .frame(minHeight: 30)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                    textFieldAction?()
                }
            
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                sendAction?(text)
                text = ""
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(text.isEmpty ? Color.blue.opacity(0.4) : Color.blue.opacity(1.0))
                    
                    Image(systemName: "paperplane")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 25, height: 25)
                        .foregroundStyle(Color.white)
                        .padding([.top, .trailing], 2)
                }
                .frame(width: 38, height: 38)
            }
            .disabled(text.isEmpty)
        }
    }
}

#Preview {
    ChatBottomView(isFocused: FocusState())
}
