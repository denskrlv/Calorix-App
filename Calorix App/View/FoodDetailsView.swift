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

    init(passedFoodItem: Item?) {
        if let foodItem = passedFoodItem {
            _selectedFoodItem = State(initialValue: foodItem)
            _name = State(initialValue: foodItem.name ?? "")
            _weight = State(initialValue: foodItem.weight ?? "")
            _calories = State(initialValue: foodItem.calories ?? "")
            _dayTime = State(initialValue: foodItem.dayTime ?? "")
            _timestamp = State(initialValue: foodItem.timestamp ?? Date())
        } else {
            _name = State(initialValue: "")
            _weight = State(initialValue: "")
            _calories = State(initialValue: "")
            _dayTime = State(initialValue: "")
            _timestamp = State(initialValue: Date())
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Weight", text: $weight)
                    .keyboardType(.numberPad)
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
            selectedFoodItem?.weight = weight
            selectedFoodItem?.calories = calculateCalories(name: name, weight: weight)
            selectedFoodItem?.dayTime = dayTime
            selectedFoodItem?.timestamp = timestamp

            foodHolder.saveContext(viewContext)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func calculateCalories(name: String?, weight: String?) -> String? {
        guard let name = name, let weight = Double(weight ?? "0") else {
            return nil
        }
        return String(Database.getCaloriesPerG(key: name) * weight)
    }
}

struct FoodDetails_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailsView(passedFoodItem: Item())
    }
}

