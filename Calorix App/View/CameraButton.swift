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

    @State var food: String
    
    var onDismiss: () -> ()
     
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
                            .frame(width: 180, height: 60)
                            .cornerRadius(60)
                        HStack {
                            Image(systemName: "camera.viewfinder")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .foregroundColor(.white)
                            Spacer()
                                .frame(maxWidth: 16)
                            Text("Food Scan")
                                .font(.system(size: 20, weight: .medium))
                        }
                    }
                }
                .sheet(isPresented: $cameraPresented, onDismiss: {
                    onDismiss()
                }, content: {
                    CameraView(food: $food)
                        .environmentObject(foodHolder)
                })
                .foregroundColor(.white)
                .padding(30)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
            }
        }
    }
    private func printt(){
        print(self.food)
    }
}


