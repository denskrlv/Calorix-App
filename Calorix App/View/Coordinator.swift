//
//  Coordinator.swift
//  Calorix App
//
//  Created by Serkan Akın on 24/01/2023.
//
import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var passedFoodItem: Item?
    @Binding var timestamp: Date

    init(passedFoodItem: Binding<Item?>, timestamp: Binding<Date>) {
        _passedFoodItem = passedFoodItem
        _timestamp = timestamp
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        image = Image(uiImage: uiImage)
        CameraView(passedFoodItem: nil, timestamp: timestamp).classifyImage(uiImage)
//        isShowing = false
    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        isShowing = false
//    }
}
