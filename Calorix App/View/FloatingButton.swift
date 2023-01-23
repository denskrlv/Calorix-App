//
//  FloatingButton.swift
//  Calorix App
//
//  Created by Denis Krylov on 16/01/2023.
//

import SwiftUI

struct FloatingButton: View {
    
    @EnvironmentObject var foodHolder: FoodHolder
    @State var foodDetailsPresented: Bool = false
    @Binding var pickedDate: Date
    
    var onDismiss: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    foodDetailsPresented.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color(UIColor.systemGreen))
                            .frame(width: 60, height: 60)
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 30)
                            .foregroundColor(.white)
                    }
                }
                .sheet(isPresented: $foodDetailsPresented, onDismiss: {
                    onDismiss()
                }, content: {
                    FoodDetailsView(passedFoodItem: nil, hideNavigationBar: false, timestamp: pickedDate)
                        .environmentObject(foodHolder)
                })
                .foregroundColor(.white)
                .padding(30)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
            }
        }
    }
}

//struct FloatingButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FloatingButton {
//            
//        }
//    }
//}

