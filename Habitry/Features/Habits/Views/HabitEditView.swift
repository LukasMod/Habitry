//
//  HabitEditView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

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
