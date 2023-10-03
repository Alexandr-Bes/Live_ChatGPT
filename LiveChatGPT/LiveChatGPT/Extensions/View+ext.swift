//
//  View+ext.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 03.10.2023.
//

import SwiftUI

extension View {
    func endEditing(_ force: Bool = true) {
        UIApplication.shared.connectedScenes.forEach { $0.inputView?.endEditing(force)}
    }
}
