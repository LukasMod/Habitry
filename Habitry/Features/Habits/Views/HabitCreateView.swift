//
//  HabitCreateView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import SwiftUI

struct HabitCreateView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: HabitCreateViewModel

    init(viewModel: HabitCreateViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: AppSpacing.m) {
                TextField("Habit name", text: $viewModel.name)
                    .textInputAutocapitalization(.sentences)
                Spacer()
            }
            .padding(AppSpacing.m)
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
}
