//
//  HabitEditView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import SwiftUI
import Combine

struct HabitEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: HabitEditViewModel

    init(viewModel: HabitEditViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: Layout.spacing) {
                Text(viewModel.titleText)
                    .font(.title2)
                Spacer()
            }
            .padding(Layout.spacing)
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

private enum Layout {
    static let spacing: CGFloat = 16
}
