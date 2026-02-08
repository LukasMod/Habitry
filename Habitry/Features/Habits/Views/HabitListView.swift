//
//  HabitListView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import SwiftUI

struct HabitListView: View {
    @ObservedObject var viewModel: HabitListViewModel

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
