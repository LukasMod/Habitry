//
//  HabitDetailView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 01/02/2026.
//

import CoreData
import SwiftUI

struct HabitDetailView: View {
  let viewModel: HabitDetailsViewModel
  @State private var isEditPresented = false
  @Environment(\.dismiss) private var dismiss

  init(viewModel: HabitDetailsViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    ScrollView {

      VStack(alignment: .leading, spacing: AppSpacing.m) {
        Text("Entries")
          .font(.headline)

        if viewModel.entries.isEmpty {
          Text("No entries yet")
            .foregroundStyle(.secondary)
        } else {
          ForEach(viewModel.entries) { entry in
            HStack {
              Text(entry.dateText)
            }
            .padding(.vertical, AppSpacing.xs)
          }
        }

      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(AppSpacing.m)
    }
    .navigationTitle(viewModel.nameText)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Edit") {
          isEditPresented = true
        }
      }
    }
    .sheet(isPresented: $isEditPresented) {
      HabitEditView(
        viewModel: viewModel.makeEditViewModel(),
        onDelete: {
          isEditPresented = false
          dismiss()
        }
      )
    }
  }
}

#Preview("Habit details") {
  let context = PersistenceController.preview.container.viewContext
  let repository = CoreDataHabitRepository(viewContext: context)
  let habit = HabitEntity(context: context)
  habit.id = UUID()
  habit.name = "Preview Habit"
  habit.createdAt = Date()

  let calendar = Calendar.current
  for dayOffset in 0..<5 {
    if let entryDate = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) {
      let entry = HabitEntryEntity(context: context)
      entry.id = UUID()
      entry.date = entryDate
      entry.createdAt = entryDate
      entry.habit = habit
    }
  }

  let viewModel = HabitDetailsViewModel(habit: habit, repository: repository)
  return NavigationStack {
    HabitDetailView(viewModel: viewModel)
  }
}
