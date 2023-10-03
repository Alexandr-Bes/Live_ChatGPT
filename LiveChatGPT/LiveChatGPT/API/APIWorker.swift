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
    
    let openAIURL = URL(string: Constants.openAIEndpoint.rawValue)
    let openAIKey = Constants.apiKey.rawValue
    
    @Published var messageLog: [[String: String]] = [
        ["role": "assistant", "content": "Hello! How can I help you?"],
        ["role": "user", "content": "You're a friendly, helpful assistant"]
    ]

    func sendToAssistant() {
        var request = URLRequest(url: self.openAIURL!)
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
//            httpBodyJson = try JSONEncoder().encode(httpBody)
            httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        } catch {
            print("Unable to convert to JSON \(error)")
            logMessage("error", messageUserType: .assistant)
        }
        
        request.httpBody = httpBodyJson
        
        if let requestData = executeRequest(request: request, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            print(jsonStr)
            let responseHandler = OpenAIResponseHandler()
            logMessage((responseHandler.decodeJson(jsonString: jsonStr)?.choices[0].message["content"])!, messageUserType: .assistant)
        }

        
    }
}


extension Dictionary: Identifiable { public var id: UUID { UUID() } }
extension Array: Identifiable { public var id: UUID { UUID() } }
extension String: Identifiable { public var id: UUID { UUID() } }

extension OpenAIConnector {
    private func executeRequest(request: URLRequest, withSessionConfig sessionConfig: URLSessionConfiguration?) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        let session: URLSession
        if let sessionConfig = sessionConfig {
            session = URLSession(configuration: sessionConfig)
        } else {
            session = URLSession.shared
        }
        var requestData: Data?
        let task = session.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print("error: \(error!.localizedDescription): \(error!.localizedDescription)")
            } else if data != nil {
                requestData = data
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
        return requestData
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

struct OpenAIResponseHandler {
    func decodeJson(jsonString: String) -> OpenAIResponse? {
        let json = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(OpenAIResponse.self, from: json)
            return product
            
        } catch {
            print("Error decoding OpenAI API Response -- \(error)")
        }
        
        return nil
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
