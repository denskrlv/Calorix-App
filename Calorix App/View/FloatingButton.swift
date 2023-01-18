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
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                NavigationLink(destination: FoodDetailsView(passedFoodItem: nil)
                    .environmentObject(foodHolder)) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color(UIColor.systemGreen))
                                .frame(width: 70, height: 70)
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .foregroundColor(.white)
                        }
                }
                .foregroundColor(.white)
                .padding(30)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
            }
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton()
    }
}

