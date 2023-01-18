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
                    Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 20, maxHeight: 20)
                }
                .padding(20)
                .foregroundColor(.white)
                .background(Color(UIColor.systemGreen))
                .cornerRadius(60)
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

