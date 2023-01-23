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

    @State var hideNavigationBar: Bool
    @State var alertIsPresented: Bool = false
    
    @State var selectedFoodItem: Item?
    @State var name: String
    @State var weight: String
    @State var totalWeight: String
    @State var calories: String
    @State var dayTime: String
    @State var timestamp: Date
    @State var groupNumber: String
    @State var quantity: Int = 1
    @State var eatingMood: String

    init(passedFoodItem: Item?, hideNavigationBar: Bool, timestamp: Date) {
        _hideNavigationBar = State(initialValue: hideNavigationBar)
        if let foodItem = passedFoodItem {
            _selectedFoodItem = State(initialValue: foodItem)
            _name = State(initialValue: foodItem.name ?? "")
            _weight = State(initialValue: foodItem.weight ?? "")
            _totalWeight = State(initialValue: foodItem.totalWeight ?? "")
            _calories = State(initialValue: foodItem.calories ?? "")
            _dayTime = State(initialValue: foodItem.dayTime ?? "Breakfast")
            _timestamp = State(initialValue: foodItem.timestamp ?? timestamp)
            _groupNumber = State(initialValue: foodItem.groupNumber ?? "A")
            _quantity = State(initialValue: Int(truncating: foodItem.quantity ?? NSDecimalNumber(value: 1)))
            _eatingMood = State(initialValue: foodItem.eatingMood ?? "Yes")
        } else {
            _name = State(initialValue: "")
            _weight = State(initialValue: "")
            _totalWeight = State(initialValue: "")
            _calories = State(initialValue: "")
            _dayTime = State(initialValue: "Breakfast")
            _timestamp = State(initialValue: timestamp)
            _groupNumber = State(initialValue: "A")
            _quantity = State(initialValue: Int(truncating: NSDecimalNumber(value: 1)))
            _eatingMood = State(initialValue: "Yes")
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Food details") {
                    TextField("Name", text: $name)
                    TextField("Grams", text: $weight)
                        .keyboardType(.numberPad)
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10,  step: 1)
                }
                
                Section("Day when consumed") {
                    DatePicker("Date", selection: $timestamp, in: ...Date.now)
                    Picker("Type", selection: $dayTime) {
                        ForEach(["Breakfast", "Lunch", "Snack", "Dinner"], id: \.self) { cardType in
                            Text(String(cardType)).tag(String(cardType))
                        }
                    }
                }
                
                Section("Eating mood") {
                    Picker("Where you hungry?", selection: $eatingMood) {
                        ForEach(["Yes", "No"], id: \.self) { cardType in
                            Text(String(cardType)).tag(String(cardType))
                        }
                    }
                }
                
                Section {
                    Button("Save", action: saveItem)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Color(UIColor.systemGreen))
                        .font(.system(size: 18, weight: .medium))
                }
                
                if hideNavigationBar {
                    Section {
                        Button {
                            alertIsPresented.toggle()
                        } label: {
                            Text("Delete")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Color(UIColor.systemRed))
                        .font(.system(size: 18, weight: .medium))
                        .alert(isPresented: $alertIsPresented) {
                            Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this meal?"), primaryButton: .destructive(Text("Delete")) {
                                deleteItem()
                            }, secondaryButton: .cancel())
                        }
                    }
                }
            }
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(hideNavigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
            .foregroundColor(Color(UIColor.label))
        }
    }

    private func saveItem() {
        withAnimation {
            if selectedFoodItem == nil {
                selectedFoodItem = Item(context: viewContext)
            }
            selectedFoodItem?.name = name
            selectedFoodItem?.weight = weight
            selectedFoodItem?.totalWeight = calculateWeight(weight: weight)
            selectedFoodItem?.calories = calculateCalories(name: name, weight: weight)
            selectedFoodItem?.dayTime = dayTime
            selectedFoodItem?.timestamp = timestamp
            selectedFoodItem?.groupNumber = selectedFoodItem?.encodeDayTime()
            selectedFoodItem?.quantity = NSDecimalNumber(value: quantity)
            selectedFoodItem?.eatingMood = eatingMood
            
            if selectedFoodItem?.name != "" {
                foodHolder.saveContext(viewContext)
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func deleteItem() {
        if selectedFoodItem != nil {
            viewContext.delete(selectedFoodItem!)
        }
        foodHolder.saveContext(viewContext)
        self.presentationMode.wrappedValue.dismiss()
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
}

struct FoodDetails_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailsView(passedFoodItem: Item(), hideNavigationBar: true, timestamp: Date())
    }
}

