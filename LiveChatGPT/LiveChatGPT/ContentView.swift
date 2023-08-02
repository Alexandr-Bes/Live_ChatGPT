//
//  ContentView.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 02.08.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe.europe.africa")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Hello! We are building ChatGPT live chat. So take your sit and wait...🤓")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
