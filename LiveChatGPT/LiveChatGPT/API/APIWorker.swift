//
//  APIWorker.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 21.08.2023.
//

import Foundation

class APIWorker {
    private let apiKey: String

//    private let HTTPClient
    
//    func sendMessage(text: String)  async throws -> AsyncThrowingStream<String, Error> {
//
//    }
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
}

import Combine

class OpenAIConnector: ObservableObject {
    
    let openAIURL = URL(string: Environment.baseURL)
    let openAIKey = Environment.apiKey
    
    @Published var messageLog: [[String: String]] = [
//        ["role": "assistant", "content": "Hello! How can I help you?"],
//        ["role": "user", "content": "You're a friendly, helpful assistant"]
    ]

    func sendToAssistant() {
        guard let url = URL(string: Environment.baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
        
        let httpBody: [String: Any] = [
            /// Use different type of chat models here.
            "model": "gpt-3.5-turbo",
            "messages": messageLog
        ]
        
        var httpBodyJson: Data?

        do {
            httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        } catch {
            print("Unable to convert to JSON \(error)")
            logMessage("error", messageUserType: .assistant)
        }
        
        request.httpBody = httpBodyJson
        
        if let requestData = executeRequest(request: request) {
            guard let jsonString = String(data: requestData, encoding: .utf8)
            else {
                return
            }
            print(jsonString)
            
            guard let responseData = try? OpenAIResponse.decode(data: requestData) 
            else {
                guard let error = try? ErrorModel.decode(data: requestData) else {
                    // TODO: - Handle error
                    return
                }
                logMessage(error.message ?? "", messageUserType: .assistant)
                return
            }
            
            logMessage((responseData.choices[0].message["content"])!, messageUserType: .assistant)
        }

    }
}


extension Dictionary: Identifiable { public var id: UUID { UUID() } }
extension Array: Identifiable { public var id: UUID { UUID() } }
extension String: Identifiable { public var id: UUID { UUID() } }

extension OpenAIConnector {
    private func executeRequest(request: URLRequest) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        
        var responseData: Data?
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            
            if let data = data {
                responseData = data
            }
            
            print("Semaphore signalled")
            semaphore.signal()
        }
        task.resume()
        
        // Handle async with semaphores. Max wait of 20 seconds
        let timeout = DispatchTime.now() + .seconds(20)
        print("Waiting for semaphore signal")
        let retVal = semaphore.wait(timeout: timeout)
        print("Done waiting, obtained - \(retVal)")
        
        return responseData
    }
}

extension OpenAIConnector {
    func logMessage(_ message: String, messageUserType: MessageUserType) {
        var messageUserTypeString = ""
        switch messageUserType {
        case .user:
            messageUserTypeString = "user"
        case .assistant:
            messageUserTypeString = "assistant"
        }
        
        messageLog.append(["role": messageUserTypeString, "content": message])
    }
    
    enum MessageUserType {
        case user
        case assistant
    }
}

struct OpenAIResponse: Codable {
    var id: String?
    var object: String?
    var created: Int?
    var choices: [Choice]
    var usage: Usage?
}

struct Choice: Codable {
    var index: Int?
    var message: [String: String]
    var finishReason: String?
}


struct Usage: Codable {
    var promptTokens: Int?
    var completionTokens: Int?
    var totalTokens: Int?
}



struct ErrorModel: Codable {
    let message: String?
    let type: String?
    let code: String?
    
    init(from decoder: Decoder) throws {
        let errorData = try ErrorRawResponse(from: decoder)
        self.message = errorData.error.message
        self.type = errorData.error.type
        self.code = errorData.error.code
//        self.message = try container.decodeIfPresent(String.self, forKey: .message)
//        self.type = try container.decodeIfPresent(String.self, forKey: .type)
//        self.code = try container.decodeIfPresent(String.self, forKey: .code)
    }
}

struct ErrorRawResponse: Codable {
    let error: ErrorData
    
    struct ErrorData: Codable {
        let message: String?
        let type: String?
        let code: String?
    }
}
