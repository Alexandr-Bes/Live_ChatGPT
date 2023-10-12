//
//  ContentView.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 02.08.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var connector = OpenAIConnector()
//    @State var text = ""
    
    @FocusState private var isFocused: Bool
    
    @State private var alreadyAnimated = false
    @State private var revealedText = ""
    private let textToAnimate = "Hello! It's ChatGPT here!"
    @State private var isAnimating = false
    
    @State private var pulsate = false
    @State private var showWaves = false
    
    @State private var isValid = true
    
    var body: some View {
        ZStack {
            backgroundGradient()
            
            if connector.messageLog.isEmpty {
                showStartButton()
                    .onTapGesture {
                        startAnimatingText()
                    }
            }
            
            VStack {
                ScrollView {
                    ForEach(connector.messageLog) { message in
                        MessageView(message: message)
                    }
                }
                
               bottomView()
                
            }.padding()
        }
    }
    
    @ViewBuilder private func backgroundGradient() -> some View {
        // swiftlint:disable:next line_length
        RadialGradient(gradient: Gradient(colors: [Color.yellow, .mint, Color.blue]), center: .center, startRadius: 2, endRadius: 500)
        .scaleEffect(1.2)
    }
    
    @ViewBuilder private func showStartButton() -> some View {
        HStack(spacing: 5) {
            ZStack {
                Circle() // Wave
                    .stroke(lineWidth: 2)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .scaleEffect(showWaves ? 2 : 1).hueRotation(.degrees(showWaves ? 360 : 0))
                    .opacity(showWaves ? 0 : 1)
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false).speed(1),
                               value: showWaves)
                    .onAppear {
                        self.showWaves.toggle()
                    }
                Circle() // Central
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .scaleEffect(pulsate ? 1 : 1.2)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).speed(1), 
                               value: pulsate)
                    .onAppear {
                        self.pulsate.toggle()
                    }
                Image(systemName: "play.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .scaleEffect(isAnimating ? 0.5 : 1)
            
            if isAnimating {
                Text(revealedText)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: isAnimating)
            }
        }
    }
    
    @ViewBuilder private func bottomView() -> some View {
        ChatBottomView(isFocused: _isFocused) { text in
            connector.logMessage(text, messageUserType: .user)
            connector.sendToAssistant()
            print("Typed message: \(text)")
        } textFieldAction: {
            startAnimatingText()
        } pickImageAction: {
            let _ = print("pickImageAction")
        }
        .onChange(of: isFocused) {
            if !isFocused && connector.messageLog.isEmpty {
                alreadyAnimated = false
                withAnimation {
//                                    pulsate = true
//                                    showWaves = true
                    revealedText = ""
                    isAnimating = false
                }
            }
        }
    }
    
    private func startAnimatingText() {
        guard !alreadyAnimated else { return }
        
//        pulsate = false
//        showWaves = false
        
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard currentIndex < textToAnimate.count else {
                alreadyAnimated = true
                timer.invalidate()
                return
            }
            let index = textToAnimate.index(textToAnimate.startIndex, offsetBy: currentIndex)
            revealedText += String(textToAnimate[index])
            currentIndex += 1
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
        isAnimating = true
    }
}

#Preview {
    ContentView()
}
