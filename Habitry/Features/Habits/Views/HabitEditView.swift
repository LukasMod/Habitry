//
//  HabitEditView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import CoreData
import SwiftUI

struct HabitEditView: View {
  @Environment(\.dismiss) private var dismiss
    let onDelete: () -> Void
    let viewModel: HabitEditViewModel

    init(
        viewModel: HabitEditViewModel,
        onDelete: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onDelete = onDelete
    }

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading, spacing: AppSpacing.m) {
        Text(viewModel.titleText)
          .font(.title2)
        Spacer()
      }
      .padding(AppSpacing.m)
      .navigationTitle(viewModel.titleText)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Back") {
            dismiss()
          }
        }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete") {
                        viewModel.deleteHabit()
                        onDelete()
                    }
                    .tint(.red)
                }
      }
    }
  }
}

#if DEBUG
#Preview("Habit Edit") {
  @Previewable @State var isPresented = true
  let context = PreviewContext.viewContext
  let habit = HabitEntity(context: context)
  habit.id = UUID()
  habit.name = "Edit Me"
  habit.createdAt = Date()
  let viewModel = HabitEditViewModel(habit: habit, repository: PreviewContext.repository)
  return Button("Show Habit Edit") { isPresented = true }
    .sheet(isPresented: $isPresented) {
      HabitEditView(viewModel: viewModel, onDelete: { isPresented = false })
    }
}
#endif
