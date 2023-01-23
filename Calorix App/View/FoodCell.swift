//
//  FoodCell.swift
//  Calorix App
//
//  Created by Denis Krylov on 16/01/2023.
//

import SwiftUI

struct FoodCell: View {
    
    @EnvironmentObject var foodHolder: FoodHolder
    @ObservedObject var passedFoodItem: Item
    
    var body: some View {
        HStack {
            VStack {
                Text(passedFoodItem.name ?? "")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(passedFoodItem.totalWeight ?? "") gram")
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if passedFoodItem.eatingMood == "No" {
                Spacer()
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Color(UIColor.systemRed))
            }
            
            Spacer()
            Text("\(passedFoodItem.calories ?? "0") KCAL")
                .font(.system(size: 14, weight: .semibold))
        }
    }
}

struct FoodCell_Previews: PreviewProvider {
    static var previews: some View {
        FoodCell(passedFoodItem: Item())
    }
}
