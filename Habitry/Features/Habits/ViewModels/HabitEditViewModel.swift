//
//  HabitEditViewModel.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import CoreData

@MainActor
final class HabitEditViewModel {
    private let habit: HabitEntity

    init(habit: HabitEntity) {
        self.habit = habit
    }

    var titleText: String {
        habit.name ?? "Name"
    }
}
