//
//  TextRecognitionHandler.swift
//  LiveChatGPT
//
//  Created by AlexBezkopylnyi on 12.10.2023.
//

import UIKit
import Vision

typealias TextRecognitionCompletion = ((String?)->())

class TextRecognitionHandler {
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func recognizeText(completion: TextRecognitionCompletion?) {
        guard let cgImage = image.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil
            else {
                return
            }
            let text = observations.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: ", ")
            print(text)
            completion?(text)
        }
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
//        request.recognitionLanguages = ["en"]
        
        do {
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
            completion?(nil)
        }
    }
}
