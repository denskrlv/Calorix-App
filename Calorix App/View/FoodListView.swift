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

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            VStack {
                ProgressBar(consumedCalories: $progress)
                    .onAppear {
                        getConsumedCalories()
                    }
                ZStack {
                    List {
                        ForEach(items) { item in
                            NavigationLink(destination: FoodDetailsView(passedFoodItem: item)
                                .environmentObject(foodHolder)) {
                                    FoodCell(passedFoodItem: item)
                                        .environmentObject(foodHolder)
                            }
                        }
                        .onDelete(perform: deleteItems)
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
        }
    }
    
    private func getConsumedCalories() {
        progress = 0
        for item in items {
            guard let caloriesDouble = Double(item.calories ?? "0") else {
                progress = 0
                break
            }
            progress += caloriesDouble
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            foodHolder.saveContext(viewContext)
            getConsumedCalories()
        }
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
