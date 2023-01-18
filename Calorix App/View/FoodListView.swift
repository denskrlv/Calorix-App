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
    @State var presentFoodDetails: Bool = false

    @SectionedFetchRequest<String?, Item>(
        sectionIdentifier: \.groupNumber,
        sortDescriptors: [SortDescriptor(\.groupNumber, order: .forward)]
    )
    private var sectionedItems: SectionedFetchResults<String?, Item>
    
    var body: some View {
        NavigationView {
            VStack {
                ProgressBar(consumedCalories: $progress)
                    .onAppear {
                        updateCalories()
                    }
                ZStack {
                    List {
                        ForEach(sectionedItems) { section in
                            Section(header: Text(decodeDayTime(groupNumber:section.id ?? ""))) {
                                ForEach(section) { item in
                                    NavigationLink(destination: FoodDetailsView(passedFoodItem: item)
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
                    .navigationTitle("\(Date(), formatter: dateFormatter)")
                    .navigationBarTitleDisplayMode(.inline)
                    HStack {
                        CameraButton()
                        Spacer()
                        FloatingButton()
                    }
                    .frame(maxWidth: .infinity, alignment: .bottom)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.right")
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
