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
    private let repository: HabitRepository

    init(habit: HabitEntity, repository: HabitRepository) {
        self.habit = habit
        self.repository = repository
    }

    var titleText: String {
        habit.name ?? "Name"
    }

    func deleteHabit() {
        repository.deleteHabits(habits: [habit])
    }
}
