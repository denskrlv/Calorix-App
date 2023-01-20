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
    
    @State var foodDetailsViewPresented: Bool = false
    @State var userViewPresented: Bool = false

    @SectionedFetchRequest<String?, Item>(
        sectionIdentifier: \.groupNumber,
        sortDescriptors: [SortDescriptor(\.groupNumber, order: .forward), SortDescriptor(\.timestamp, order: .forward)]
//        predicate: NSPredicate(format: "timestamp >= @% AND timestamp < @%", calendar.startOfDay(for: Date()) as NSDate)
    )
    private var sectionedItems: SectionedFetchResults<String?, Item>
    
    var body: some View {
        NavigationView {
            VStack {
                ProgressBar(consumedCalories: $progress)
                ZStack {
                    List {
                        ForEach(sectionedItems) { section in
                            Section(header: Text(decodeDayTime(groupNumber:section.id ?? ""))) {
                                ForEach(section) { item in
                                    NavigationLink(destination: FoodDetailsView(passedFoodItem: item, hideNavigationBar: true)
                                        .environmentObject(foodHolder)) {
                                            FoodCell(passedFoodItem: item)
                                        }
                                }
                                .onDelete { indexSet in
                                    deleteItem(section: Array(section), offsets: indexSet)
                                }
                            }
                        }
                    }
                    HStack {
                        CameraButton()
                        Spacer()
                        FloatingButton(onDismiss: {
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
                ToolbarItem(placement: .principal) {
                    DatePicker("label", selection: $pickedDate, displayedComponents: [.date])
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        userViewPresented.toggle()
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                    .sheet(isPresented: $userViewPresented) {
                        
                    }
                }
            }
        }
    }
    
    private func updateCalories() {
        progress = 0
        for section in sectionedItems {
            for item in section {
                guard let caloriesDouble = Double(item.calories ?? "0") else {
                    progress = 0
                    break
                }
                progress += caloriesDouble
            }
        }
    }
    
    func deleteItem(section: [Item], offsets: IndexSet) {
        for index in offsets {
            let item = section[index]
            viewContext.delete(item)
        }
        try? viewContext.save()
        updateCalories()
    }
    
    func decodeDayTime(groupNumber: String) -> String {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
