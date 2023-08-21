//
//  String+ext.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 03.08.2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    func localized(arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
