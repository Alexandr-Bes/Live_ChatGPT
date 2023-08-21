//
//  ContentView.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 02.08.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ChatViewModel()
    
    @State private var pulsate = false
    @State private var showWaves = false
    
    var body: some View {
        ZStack {
            backgroundGradient()
            
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
            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).speed(1), value: pulsate)
            .onAppear {
                self.pulsate.toggle()
            }
            Image(systemName: "play.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
        }.shadow(radius: 25)
//        .padding()
    }
    
    @ViewBuilder private func backgroundGradient() -> some View {
        // swiftlint:disable:next line_length
        RadialGradient(gradient: Gradient(colors: [Color.white, Color.green]), center: .center, startRadius: 2, endRadius: 500)
        .scaleEffect(1.2)
    }
}

// Text("MainView.HelloMessage.Title".localized)


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
