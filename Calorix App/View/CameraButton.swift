//
//  CameraButton.swift
//  Calorix App
//
//  Created by Denis Krylov on 16/01/2023.
//

import SwiftUI

struct CameraButton: View {
    
    @EnvironmentObject var foodHolder: FoodHolder
    
    @State var cameraPresented: Bool = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    cameraPresented.toggle()
                } label: {
                    Image(systemName: "camera")
                }
                .fullScreenCover(isPresented: $cameraPresented, content: {
                    ImagePickerView(selectedImage: $selectedImage, sourceType: .camera)
                })
                .padding(15)
                .foregroundColor(.white)
                .background(Color(UIColor.systemBlue))
                .cornerRadius(30)
                .padding(30)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
            }
        }
    }
}

struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        CameraButton()
    }
}
