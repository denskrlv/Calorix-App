//
//  ItemExtension.swift
//  Calorix App
//
//  Created by Denis Krylov on 23/01/2023.
//

import SwiftUI

extension Item {
    
    func encodeDayTime() -> String? {
        if dayTime == "Breakfast" {
            return "A"
        } else if dayTime == "Lunch" {
            return "B"
        } else if dayTime == "Snack" {
            return "C"
        } else if dayTime == "Dinner" {
            return "D"
        }
        return ""
    }
    
}
