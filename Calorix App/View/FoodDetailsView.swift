//
//  FoodDetailsView.swift
//  Calorix App
//
//  Created by Denis Krylov on 16/01/2023.
//

import SwiftUI

struct FoodDetailsView: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var foodHolder: FoodHolder

    @State var selectedFoodItem: Item?
    @State var name: String
    @State var weight: String
    @State var calories: String
    @State var dayTime: String
    @State var timestamp: Date
    @State var groupNumber: String
    @State var quantity: Int = 1

    init(passedFoodItem: Item?) {
        if let foodItem = passedFoodItem {
            _selectedFoodItem = State(initialValue: foodItem)
            _name = State(initialValue: foodItem.name ?? "")
            _weight = State(initialValue: foodItem.weight ?? "")
            _calories = State(initialValue: foodItem.calories ?? "")
            _dayTime = State(initialValue: foodItem.dayTime ?? "Breakfast")
            _timestamp = State(initialValue: foodItem.timestamp ?? Date())
            _groupNumber = State(initialValue: foodItem.groupNumber ?? "A")
            _quantity = State(initialValue: Int(truncating: foodItem.quantity ?? NSDecimalNumber(value: 1)))
        } else {
            _name = State(initialValue: "")
            _weight = State(initialValue: "")
            _calories = State(initialValue: "")
            _dayTime = State(initialValue: "Breakfast")
            _timestamp = State(initialValue: Date())
            _groupNumber = State(initialValue: "A")
            _quantity = State(initialValue: Int(truncating: NSDecimalNumber(value: 1)))
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Grams", text: $weight)
                    .keyboardType(.numberPad)
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10,  step: 1)
            }
            
            Section {
                Picker("Type", selection: $dayTime) {
                    ForEach(["Breakfast", "Lunch", "Snack", "Dinner"], id: \.self) { cardType in
                        Text(String(cardType)).tag(String(cardType))
                    }
                }
            }
            
            Section {
                Button("Save", action: saveItem)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveItem() {
        withAnimation {
            if selectedFoodItem == nil {
                selectedFoodItem = Item(context: viewContext)
            }
            selectedFoodItem?.name = name
            selectedFoodItem?.weight = calculateWeight(weight: weight)
            selectedFoodItem?.calories = calculateCalories(name: name, weight: weight)
            selectedFoodItem?.dayTime = dayTime
            selectedFoodItem?.timestamp = timestamp
            selectedFoodItem?.groupNumber = encodeDayTime()
            selectedFoodItem?.quantity = NSDecimalNumber(value: quantity)
            
            foodHolder.saveContext(viewContext)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func calculateWeight(weight: String?) -> String? {
        guard let weight = Double(weight ?? "0") else {
            return nil
        }
        return String(weight * Double(quantity))
    }
    
    private func calculateCalories(name: String?, weight: String?) -> String? {
        guard let name = name, let weight = Double(weight ?? "0") else {
            return nil
        }
        return String(Int(Database.getCaloriesPerG(key: name) * weight * Double(quantity)))
    }
    
    private func encodeDayTime() -> String? {
        if selectedFoodItem?.dayTime == "Breakfast" {
            return "A"
        } else if selectedFoodItem?.dayTime == "Lunch" {
            return "B"
        } else if selectedFoodItem?.dayTime == "Snack" {
            return "C"
        } else if selectedFoodItem?.dayTime == "Dinner" {
            return "D"
        }
        return ""
    }
}

struct FoodDetails_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailsView(passedFoodItem: Item())
    }
}

