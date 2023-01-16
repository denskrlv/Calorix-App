//
//  FloatingButton.swift
//  Calorix App
//
//  Created by Denis Krylov on 16/01/2023.
//

import SwiftUI

struct FloatingButton: View
{
    @EnvironmentObject var foodHolder: FoodHolder
    
    var body: some View
    {
        VStack
        {
            Spacer()
            HStack
            {
                Spacer()
                NavigationLink(destination: FoodDetailsView(passedFoodItem: nil)
                    .environmentObject(foodHolder))
                {
                    Image(systemName: "plus")
                }
                .padding(15)
                .foregroundColor(.white)
                .background(Color(UIColor.systemGreen))
                .cornerRadius(30)
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

