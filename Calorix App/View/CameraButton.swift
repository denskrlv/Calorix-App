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
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(UIColor.systemBlue))
                            .frame(width: 160, height: 60)
                            .cornerRadius(60)
                        HStack {
                            Image(systemName: "camera.viewfinder")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .foregroundColor(.white)
                            Spacer()
                                .frame(maxWidth: 16)
                            Text("AI Scan")
                                .font(.system(size: 20, weight: .medium))
                        }
                    }
                }
                .fullScreenCover(isPresented: $cameraPresented, content: {
                    ImagePickerView(selectedImage: $selectedImage, sourceType: .camera)
                })
                .foregroundColor(.white)
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
