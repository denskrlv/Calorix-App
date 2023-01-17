//
//  Database.swift
//  Calorix App
//
//  Created by Denis Krylov on 17/01/2023.
//

import Foundation

struct Database {
    
    static let foodCalories = ["Apple" : 0.52, "Banana" : 0.89, "Egg" : 1.5]
    
    static func getCaloriesPerG(key: String) -> Double {
        return foodCalories[key] ?? 0
    }
    
}
