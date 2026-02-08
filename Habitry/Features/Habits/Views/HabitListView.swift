//
//  HabitListView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import SwiftUI

struct HabitListView: View {
    @ObservedObject var viewModel: HabitListViewModel
    @State private var isCreatePresented = false

    var body: some View {
        NavigationStack {
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
                ToolbarItem {
                    Button(action: openCreate) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isCreatePresented) {
                HabitCreateView(viewModel: viewModel.makeCreateViewModel())
            }
        }
    }

    private func openCreate() {
        isCreatePresented = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteItems(offsets: offsets)
        }
    }
}
