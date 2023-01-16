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

    @State var foodDetailsPresented: Bool = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            VStack {
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
                    FloatingButton()
                }
            }
        }
    }

    private func addItem() {
        foodDetailsPresented.toggle()
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
