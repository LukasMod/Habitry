//
//  HabitEditView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import SwiftUI

struct HabitEditView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel: HabitEditViewModel

  init(viewModel: HabitEditViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
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
      }
    }
  }
}
