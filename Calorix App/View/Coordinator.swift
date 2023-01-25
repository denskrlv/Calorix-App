//
//  Coordinator.swift
//  Calorix App
//
//  Created by Serkan Akın on 24/01/2023.
//
import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isShowing: Bool
    @Binding var image: Image?
    @Binding var food: String
    
    init(isShowing: Binding<Bool>, image: Binding<Image?>, food: Binding<String>) {
        _isShowing = isShowing
        _image = image
        _food = food
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = Image(uiImage: uiImage)
        CameraView(isShowing: $isShowing, image: $image, food: $food).classifyImage(uiImage)
        isShowing = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShowing = false
    }
}
