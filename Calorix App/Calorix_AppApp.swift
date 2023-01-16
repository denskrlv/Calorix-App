//
//  Calorix_AppApp.swift
//  Calorix App
//
//  Created by Denis Krylov on 16/01/2023.
//

import SwiftUI

@main
struct Calorix_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let foodHolder = FoodHolder(context)
            FoodListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(foodHolder)
        }
    }
}
