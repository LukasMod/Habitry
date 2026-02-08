//
//  HabitEditViewModel.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import SwiftUI
import Combine

@MainActor
final class HabitEditViewModel: ObservableObject {
    private let habit: HabitEntity

    init(habit: HabitEntity) {
        self.habit = habit
    }

    var titleText: String {
        habit.name ?? "Name"
    }
}
