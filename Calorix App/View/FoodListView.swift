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

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private var totalCalories: Double = 2000
    private var consumedCalories: Double = 0

    var body: some View {
        var percent = consumedCalories / totalCalories
        NavigationView {
            VStack {
                ProgressBar(percent: percent)
                    .onAppear {
                        percent = consumedCalories / totalCalories
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            foodHolder.saveContext(viewContext)
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
