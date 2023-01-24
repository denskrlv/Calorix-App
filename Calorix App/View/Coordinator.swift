//
//  Coordinator.swift
//  Calorix App
//
//  Created by Serkan Akın on 24/01/2023.
//
import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
    @State var name = " none"
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        image = Image(uiImage: uiImage)
        CameraView(food: $name).classifyImage(uiImage)
        
            
//        isShowing = false
    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        isShowing = false
//    }
}
