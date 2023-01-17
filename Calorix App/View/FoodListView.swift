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

    @SectionedFetchRequest<String?, Item>(
        sectionIdentifier: \.dayTime,
        sortDescriptors: [SortDescriptor(\.dayTime, order: .forward)]
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
                            Section(header: Text(section.id ?? "")) {
                                ForEach(section) { item in
                                    NavigationLink(destination: FoodDetailsView(passedFoodItem: item)
                                        .environmentObject(foodHolder)) {
                                            FoodCell(passedFoodItem: item)
                                                .environmentObject(foodHolder)
                                        }
                                }
                                .onDelete { indexSet in
                                    deleteItem(section: Array(section), offsets: indexSet)
                                }
                            }
                        }
                    }
                    .navigationTitle("Food")
                    HStack {
                        CameraButton()
                        Spacer()
                        FloatingButton()
                    }
                    .frame(maxWidth: .infinity, alignment: .bottom)
                }
            }
            .background(.regularMaterial)
            .onAppear {
                print(sectionedItems)
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
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
