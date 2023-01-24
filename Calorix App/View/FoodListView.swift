//
//  ContentView.swift
//  Calorix App
//
//  Created by Denis Krylov on 16/01/2023.
//

import SwiftUI
import CoreData

struct FoodListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var foodHolder: FoodHolder
    
    @State var progress: CGFloat = 0
    @State var pickedDate: Date = Date()
    
    @State var food = " none"
    
    @State var foodDetailsViewPresented: Bool = false
    let calendar = Calendar(identifier: .gregorian)
    
    var body: some View {
        NavigationView {
            VStack {
                ProgressBar(consumedCalories: $progress)
                ZStack {
                    List {
                        ForEach(foodHolder.keys, id: \.self) { key in
                            Section(header: Text(decodeDayTime(groupNumber: key))) {
                                ForEach(foodHolder.groupedFoodItems[key]!) { item in
                                    NavigationLink(destination: FoodDetailsView(passedFoodItem: item, hideNavigationBar: true, timestamp: pickedDate)
                                        .environmentObject(foodHolder)) {
                                            FoodCell(passedFoodItem: item)
                                        }
                                }
                            }
                        }
                    }
                    .overlay {
                        if foodHolder.groupedFoodItems.isEmpty {
                            VStack {
                                Image("empty_holder")
                                    .resizable()
                                    .scaledToFit()
                                Text("You didn't log any food!")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(UIColor.systemGreen))
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 150, trailing: 0))
                        }
                    }
                    HStack {
                        CameraButton(food: food, onDismiss: {
                            updateCalories()
                        }).environmentObject(foodHolder)
                        Spacer()
                        FloatingButton(pickedDate: $pickedDate, onDismiss: {
                            updateCalories()
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .bottom)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                updateCalories()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            foodHolder.moveDate(days: -1, viewContext)
                            pickedDate = calendar.date(byAdding: .day, value: -1, to: pickedDate) ?? Date()
                            updateCalories()
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                }
                ToolbarItem(placement: .principal) {
                    DatePicker("", selection: $pickedDate, in: ...Date.now, displayedComponents: [.date])
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .onChange(of: pickedDate, perform: { value in
                            foodHolder.updateDate(newDate: value, viewContext)
                            updateCalories()
                        })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !calendar.isDateInToday(pickedDate) {
                            foodHolder.moveDate(days: 1, viewContext)
                            pickedDate = calendar.date(byAdding: .day, value: 1, to: pickedDate) ?? Date()
                            updateCalories()
                        }
                    } label: {
                        Image(systemName: "arrow.right")
                    }
                }
            }
        }
    }
    
    private func updateCalories() {
        progress = 0
        for foodKey in foodHolder.groupedFoodItems.keys {
            for item in foodHolder.groupedFoodItems[foodKey]! {
                guard let caloriesDouble = Double(item.calories ?? "0") else {
                    progress = 0
                    break
                }
                progress += caloriesDouble
            }
        }
    }
    
    private func deleteItem(section: [Item], offsets: IndexSet) {
        for index in offsets {
            let item = section[index]
            viewContext.delete(item)
        }
        try? viewContext.save()
        updateCalories()
    }
    
    private func decodeDayTime(groupNumber: String) -> String {
        if groupNumber == "A" {
            return "Breakfast"
        } else if groupNumber == "B" {
            return "Lunch"
        } else if groupNumber == "C" {
            return "Snack"
        } else if groupNumber == "D" {
            return "Dinner"
        }
        return ""
    }
    
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
