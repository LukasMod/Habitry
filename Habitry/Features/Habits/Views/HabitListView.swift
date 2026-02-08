//
//  HabitListView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import SwiftUI

struct HabitListView: View {
    @Bindable var viewModel: HabitListViewModel
    @State private var isCreatePresented = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: AppSpacing.m) {
                    ForEach(viewModel.items) { item in
                        NavigationLink {
                            HabitDetailView(
                                viewModel: HabitDetailsViewModel(habit: item)
                            )
                        } label: {
                            HabitListItemView(habit: item) {
                                viewModel.toggleCheckIn(habit: item)
                            }
                            .padding(AppSpacing.m)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(AppSpacing.m)
        
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
}
