//
//  TextEditorWithPlaceholder.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 03.10.2023.
//

import SwiftUI
import Combine

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    @State var maxChars: Int
    @State var placeholder: String
    @State private var totalChars = 0
    @State private var lastText = ""
    
    var body: some View {
        VStack(spacing: 3) {
            // MARK: - Text Editor
            ZStack(alignment: .leading) {
                VStack {
                    TextEditor(text: $text)
                        .foregroundColor(Color.accentColor)
                        .font(.system(size: 13))
                        .padding(8)
                        .frame(alignment: .topLeading)
                        .frame(minHeight: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                        .onChange(of: text, { _, newValue in
                            totalChars = newValue.count
                            
                            if totalChars <= maxChars {
                                lastText = newValue
                            } else {
                                self.text = lastText
                            }
                        })
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    endEditing()
                                }
                            }
                        }
                    
                    Spacer()
                    
                }
                
                // MARK: - Placeholder
                if text.isEmpty {
                    VStack {
                        Text(placeholder)
                            .font(.system(size: 11))
                            .foregroundColor(Color(UIColor.lightGray))
                            .padding()
                        Spacer()
                    }
                    .frame(alignment: .topLeading)
                }
            }
            
            // MARK: - Counter
            HStack {
                Spacer()
                Text("\(totalChars)/\(maxChars)")
                    .frame(alignment: .trailing)
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
        }
        
    }
}


struct KeyboardWithToolbarView<Content, ToolBar>: View where Content: View, ToolBar: View {
    //    @StateObject private var keyboard: KeyboardResponder = KeyboardResponder()
    @ObservedObject private var keyboard = KeyboardResponder()
    let toolbarFrame: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 40.0)
    var content: () -> Content
    var toolBar: () -> ToolBar
    
    var body: some View {
        ZStack {
            content()
                .padding(.bottom, (keyboard.currentHeight == 0) ? 0 : toolbarFrame.height)
            VStack {
                Spacer()
                toolBar()
                    .frame(width: toolbarFrame.width, height: toolbarFrame.height)
                    .background(Color.secondary.opacity(0.5))
            }.opacity((keyboard.currentHeight == 0) ? 0 : 1)
                .animation(.easeOut)
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut)
    }
}

// Keyboard observer (picked from here https://stackoverflow.com/a/57743709)
class KeyboardResponder: ObservableObject {
    let willset = PassthroughSubject<CGFloat, Never>()
    private var _center: NotificationCenter
    @Published var currentHeight: CGFloat = 0
    var keyboardDuration: TimeInterval = 0
    
    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        _center.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            guard let duration:TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            keyboardDuration = duration
            
            withAnimation(.easeInOut(duration: duration)) {
                self.currentHeight = keyboardSize.height
            }
            
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        guard let duration:TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        withAnimation(.easeInOut(duration: duration)) {
            currentHeight = 0
        }
    }
}


#Preview {
    TextEditorWithPlaceholder(text: .constant("hello"), maxChars: 250, placeholder: "Put")
}
