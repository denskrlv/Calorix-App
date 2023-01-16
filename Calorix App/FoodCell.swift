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
        Text(passedFoodItem.name ?? "")
    }
}

struct FoodCell_Previews: PreviewProvider {
    static var previews: some View {
        FoodCell(passedFoodItem: Item())
    }
}
