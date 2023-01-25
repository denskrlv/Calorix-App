//
//  Database.swift
//  Calorix App
//
//  Created by Denis Krylov on 17/01/2023.
//

import Foundation

struct Database {
    
    static let foodCalories = ["Apple" : 0.52, "Orange": 0.60, "Lemon": 0.40, "Pomegranate": 0.45,"Banana" : 0.89, "Egg" : 1.5, "Ketchup" : 1.3, "Tomato sauce" : 0.8, "White rice" : 0.25, "Pork schnitzel" : 1.9, "Minced beef" : 1.73, "Spaghetti" : 0.8, "Cheesecake" : 4, "Greek yoghurt" : 0.1, "Pear": 0.76, "Pasta": 1.2]
    
    static func getCaloriesPerG(key: String) -> Double {
        return foodCalories[key] ?? 0
    }
    
}
