//
//  HabitDetailView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 01/02/2026.
//

import SwiftUI

struct HabitDetailView: View {
    @StateObject private var viewModel: HabitDetailsViewModel
    @State private var isEditPresented = false

    init(viewModel: HabitDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.spacing) {
            Text("Habit details")
                .font(.headline)
            Spacer()
        }
        .padding(Layout.spacing)
        .navigationTitle(viewModel.nameText)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isEditPresented = true
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            HabitEditView(viewModel: viewModel.makeEditViewModel())
        }
    }
}

private enum Layout {
    static let spacing: CGFloat = 16
}
