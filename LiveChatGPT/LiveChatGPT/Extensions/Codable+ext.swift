//
//  Codable+ext.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 04.10.2023.
//

import Foundation

extension Decodable {
    /// Returns a value of the type you specify, decoded from a JSON object.
    static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        do {
            let _ = try JSONDecoder().decode(Self.self, from: data)
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        return try decoder.decode(Self.self, from: data)
    }
}
