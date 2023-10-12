//
//  Environment.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 05.10.2023.
//

import Foundation

protocol EnvironmentProtocol {
    static var baseURL: String { get }
    static var apiKey: String { get }
}


enum Environment: EnvironmentProtocol {
    
    // MARK: - Keys
    enum Keys {
        static let baseURL = "OPEN_AI_ENDPOINT"
        static let apiKey = "CHATGPT_API_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary
        else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    // MARK: - Base URL
    static let baseURL: String = {
        guard let baseURLString = Environment.infoDictionary[Keys.baseURL] as? String
        else {
            fatalError("Base URL doesn't exist in plist")
        }
        return baseURLString
    }()
    
    // MARK: - API key
    static let apiKey: String = {
        guard let apiKey = Environment.infoDictionary[Keys.apiKey] as? String
        else {
            fatalError("API key doesn't exist in plist")
        }
        return apiKey
    }()
}
