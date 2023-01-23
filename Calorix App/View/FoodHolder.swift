//
//  FoodHolder.swift
//  Calorix App
//
//  Created by Denis Krylov on 16/01/2023.
//

import SwiftUI
import CoreData

class FoodHolder: ObservableObject {
    
    @Published var date = Date()
    @Published var foodItem: [Item] = []
    @Published var groupedFoodItems: [String?: [Item]] = [:]
    @Published var keys: [String] = []
    
    let calendar: Calendar = Calendar.current
    
    func moveDate(days: Int, _ context: NSManagedObjectContext) {
        date = calendar.date(byAdding: .day, value: days, to: date)!
        refreshFoodItems(context)
    }
    
    func updateDate(newDate: Date, _ context: NSManagedObjectContext) {
        date = newDate
        refreshFoodItems(context)
    }
    
    init(_ context: NSManagedObjectContext) {
        refreshFoodItems(context)
    }
    
    func refreshFoodItems(_ context: NSManagedObjectContext) {
        foodItem = fetchFoodItems(context)
        groupedFoodItems = groupFetch(foodItem)
        keys = Array(groupedFoodItems.keys.map { $0! }).sorted()
    }
    
    func fetchFoodItems(_ context: NSManagedObjectContext) -> [Item] {
        do {
            return try context.fetch(dailyFoodFetch()) as [Item]
        } catch let error {
            fatalError("Unresolved error \(error)")
        }
    }
    
    func dailyFoodFetch() -> NSFetchRequest<Item> {
        let request = Item.fetchRequest()
        request.sortDescriptors = sortOrder()
        request.predicate = predicate()
        return request
    }
    
    private func sortOrder() -> [NSSortDescriptor] {
        let timeSort = NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
        return [timeSort]
    }
    
    private func predicate() -> NSPredicate {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)
        return NSPredicate(format: "timestamp >= %@ AND timestamp < %@", start as NSDate, end! as NSDate)
    }
    
    private func groupFetch(_ result : [Item]) -> [String?: [Item]] {
        return Dictionary(grouping: result, by: { $0.groupNumber })
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshFoodItems(context)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
