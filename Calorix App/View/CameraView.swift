//
//  CameraView.swift
//  Calorix App
//
//  Created by Serkan Akın on 24/01/2023.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var foodHolder: FoodHolder
    
    @State var alertIsPresented: Bool = false
    
    //    @Binding var isShowing: Bool
    //    @Binding var image: Image?
    
    @Binding var food: String
    
    
    
    //    @State var selectedFoodItem: Item?
    //    @State var name: String
    //    @State var weight: String
    //    @State var totalWeight: String
    //    @State var calories: String
    //    @State var dayTime: String
    //    @State var timestamp: Date
    //    @State var groupNumber: String
    //    @State var quantity: Int = 1
    //    @State var eatingMood: String
    //
    @State var imagePredictor = ImagePredictor()
    @State var predictionNumber = 1
    //
    //    init(passedFoodItem: Item?, timestamp: Date) {
    //        if let foodItem = passedFoodItem {
    //            _selectedFoodItem = State(initialValue: foodItem)
    //            _name = State(initialValue: foodItem.name ?? "")
    //            _weight = State(initialValue: foodItem.weight ?? "")
    //            _totalWeight = State(initialValue: foodItem.totalWeight ?? "")
    //            _calories = State(initialValue: foodItem.calories ?? "")
    //            _dayTime = State(initialValue: foodItem.dayTime ?? "Breakfast")
    //            _timestamp = State(initialValue: foodItem.timestamp ?? timestamp)
    //            _groupNumber = State(initialValue: foodItem.groupNumber ?? "A")
    //            _quantity = State(initialValue: Int(truncating: foodItem.quantity ?? NSDecimalNumber(value: 1)))
    //            _eatingMood = State(initialValue: foodItem.eatingMood ?? "Yes")
    //            _imagePredictor = State(initialValue: ImagePredictor())
    //            _predictionNumber = State(initialValue: 1)
    //        } else {
    //            _name = State(initialValue: "")
    //            _weight = State(initialValue: "")
    //            _totalWeight = State(initialValue: "")
    //            _calories = State(initialValue: "")
    //            _dayTime = State(initialValue: "Breakfast")
    //            _timestamp = State(initialValue: timestamp)
    //            _groupNumber = State(initialValue: "A")
    //            _quantity = State(initialValue: Int(truncating: NSDecimalNumber(value: 1)))
    //            _eatingMood = State(initialValue: "Yes")
    //            _imagePredictor = State(initialValue: ImagePredictor())
    //            _predictionNumber = State(initialValue: 1)
    //        }
    //    }
    
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {
        
    }
}
    
//    private func saveItem(prediction: String) {
//        withAnimation {
//            if selectedFoodItem == nil {
//                selectedFoodItem = Item(context: viewContext)
//            }
//            selectedFoodItem?.name = prediction
//            selectedFoodItem?.weight = weight
//            selectedFoodItem?.totalWeight = calculateWeight(weight: weight)
//            selectedFoodItem?.calories = calculateCalories(name: name, weight: weight)
//            selectedFoodItem?.dayTime = dayTime
//            selectedFoodItem?.timestamp = timestamp
//            selectedFoodItem?.groupNumber = selectedFoodItem?.encodeDayTime()
//            selectedFoodItem?.quantity = NSDecimalNumber(value: quantity)
//            selectedFoodItem?.eatingMood = eatingMood
//            print(foodHolder)
//            if selectedFoodItem?.name != "" {
//                foodHolder.saveContext(viewContext)
//            }
//            self.presentationMode.wrappedValue.dismiss()
//        }
//    }
//
    
//    private func calculateWeight(weight: String?) -> String? {
//        guard let weight = Double(weight ?? "0") else {
//            return nil
//        }
//        return String(weight * Double(quantity))
//    }
//
//    private func calculateCalories(name: String?, weight: String?) -> String? {
//        guard let name = name, let weight = Double(weight ?? "0") else {
//            return nil
//        }
//        return String(Int(Database.getCaloriesPerG(key: name) * weight * Double(quantity)))
//    }
//}

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
        print(predictionString)
        self.food = predictionString
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

//struct FoodDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodDetailsView(passedFoodItem: Item(), hideNavigationBar: true, timestamp: Date())
//    }
//}


