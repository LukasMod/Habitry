//
//  ContentView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 01/02/2026.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: HabitListViewModel

    init(viewContext: NSManagedObjectContext) {
        let repository = CoreDataHabitRepository(viewContext: viewContext)
        _viewModel = StateObject(
            wrappedValue: HabitListViewModel(repository: repository)
        )
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        HabitDetailView(
                            viewModel: HabitDetailsViewModel(habit: item)
                        )
                    } label: {
                        Text(item.name ?? "Name")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            viewModel.addHabit()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteItems(offsets: offsets)
        }
    }
}

#Preview {
    ContentView(
        viewContext: PersistenceController.preview.container.viewContext
    )
}
