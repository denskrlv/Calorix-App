//
//  CameraButton.swift
//  Calorix App
//
//  Created by Denis Krylov on 16/01/2023.
//

import SwiftUI

struct CameraButton: View {
    
    @EnvironmentObject var foodHolder: FoodHolder
    @Environment(\.managedObjectContext) private var viewContext
    @State var cameraPresented: Bool = false
    
    @State var pickedDate: Date = Date()
    
    @State private var isShowingCamera: Bool = false
    @State private var image: Image?

    @State var food: String
    
    var onDismiss: () -> ()
     
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    isShowingCamera.toggle()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(UIColor.systemBlue))
                            .frame(width: 180, height: 60)
                            .cornerRadius(60)
                        HStack {
                            Image(systemName: "camera.viewfinder")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .foregroundColor(.white)
                            Spacer()
                                .frame(maxWidth: 16)
                            Text("Food Scan")
                                .font(.system(size: 20, weight: .medium))
                        }
                    }
                }
                .sheet(isPresented: $isShowingCamera, onDismiss: {
                    printt(prediction: food)
                }, content: {
                    CameraView(isShowing: self.$isShowingCamera, image: self.$image, food: $food)
//                        .environmentObject(foodHolder)
                })
                .foregroundColor(.white)
                .padding(30)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
            }
        }
    }
    public func printt(prediction: String){
        self.food = prediction
        print(pickedDate)
        let weight = generateRandomWeight()
        let dayTime = getDayTime(timestamp: pickedDate)
        let foodItem  = Item(context: viewContext)
        foodItem.name = self.food
        foodItem.weight = weight
        foodItem.totalWeight = calculateWeight(weight: weight)
        foodItem.calories = calculateCalories(name: self.food, weight: weight)
        foodItem.dayTime = dayTime
        foodItem.groupNumber = encodeDayTime(dayTime: dayTime)
        foodItem.timestamp = pickedDate
        foodItem.quantity = NSDecimalNumber(value: 1)
        foodItem.eatingMood = "Yes"
        foodHolder.saveContext(viewContext)
        var progress = 0
        for foodKey in foodHolder.groupedFoodItems.keys {
            for item in foodHolder.groupedFoodItems[foodKey]! {
                guard let caloriesDouble = Double(item.calories ?? "0") else {
                    progress = 0
                    break
                }
                progress += Int(caloriesDouble)
            }
        }
    }
    private func getDayTime(timestamp: Date) -> String{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: timestamp)
        if hour > 5 && hour < 11{
            return "Breakfast"
        } else if hour > 11 && hour < 18{
            return "Lunch"
        } else if hour > 18 && hour < 22{
            return "Dinner"
        } else{
            return "Snack"
        }
    }
    
    func encodeDayTime(dayTime: String) -> String? {
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
    
    private func calculateWeight(weight: String?) -> String? {
        guard let weight = Double(weight ?? "0") else {
            return nil
        }
        return String(weight * Double(1))
    }
    
    private func calculateCalories(name: String?, weight: String?) -> String? {
        guard let name = name, let weight = Double(weight ?? "0") else {
            return nil
        }
        return String(Int(Database.getCaloriesPerG(key: name) * weight * Double(1)))
    }
    
    private func generateRandomWeight() -> String{
        return String(Int.random(in: 100...500))
    }
}


