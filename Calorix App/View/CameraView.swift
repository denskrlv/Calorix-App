//
//  CameraView.swift
//  Calorix App
//
//  Created by Serkan Akın on 24/01/2023.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool
    @Binding var image: Image?
    
    @Binding var food: String
    
    let imagePredictor = ImagePredictor()
    
    let predictionNumber = 1
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, image: $image, food: $food)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
//
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {

    }
    
}

extension CameraView {
    /// Updates the storyboard's prediction label.
    /// - Parameter message: A prediction or message string.
    /// - Tag: updatePredictionLabel
    func updatePredictionLabel(_ message: String) {
        DispatchQueue.main.async {
//            self.predictionLabel.text = message
        }
    }
}



extension CameraView {
    // MARK: Image prediction methods
    /// Sends a photo to the Image Predictor to get a prediction of its content.
    /// - Parameter image: A photo.
    public func classifyImage(_ image: UIImage) {
        do {
            try self.imagePredictor.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }
    
    /// The method the Image Predictor calls when its image classifier model generates a prediction.
    /// - Parameter predictions: An array of predictions.
    /// - Tag: imagePredictionHandler
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            updatePredictionLabel("No predictions. (Check console log.)")
            return
        }
        
        let formattedPredictions = formatPredictions(predictions)
        
        let predictionString = formattedPredictions.joined(separator: "\n")
        let readyPrediction = predictionString.components(separatedBy: " - ")[0].capitalized
        print(readyPrediction)
        food = readyPrediction
        updatePredictionLabel(predictionString)
    }
    
    /// Converts a prediction's observations into human-readable strings.
    /// - Parameter observations: The classification observations from a Vision request.
    /// - Tag: formatPredictions
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionNumber).map { prediction in
            var name = prediction.classification
            
            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }
            
            return "\(name) - \(prediction.confidencePercentage)%"
        }
        
        return topPredictions
    }
}
