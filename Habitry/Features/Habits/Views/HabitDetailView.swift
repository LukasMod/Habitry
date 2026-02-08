//
//  HabitDetailView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 01/02/2026.
//

import SwiftUI

struct HabitDetailView: View {
    @StateObject private var viewModel: HabitDetailsViewModel

    init(viewModel: HabitDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            Text("Habit Detail")
            Text("Name: \(viewModel.nameText)")
            Text("Current Streak: \(viewModel.currentStreakText)")
            Text("Longest Streak: \(viewModel.longestStreakText)")
            Text("Created At: \(viewModel.createdAtText)")
            Text("Is Archived: \(viewModel.isArchivedText)")
            Text("Target Value: \(viewModel.targetValueText)")
            Text("Unit: \(viewModel.unitText)")
            Text("Entries:")

            if viewModel.entries.isEmpty {
                Text("No Entries")
            } else {
                ForEach(viewModel.entries) { entry in
                    HStack {
                        Text("index: \(entry.index)")
                        Text("Date: \(entry.dateText)")
                        Text("Value: \(entry.valueText)")
                        Spacer()
                    }
                }
            }
        }
    }
}
