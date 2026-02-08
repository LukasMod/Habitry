//
//  HabitCreateViewModel.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class HabitCreateViewModel {
  var name: String = ""

  private let repository: HabitRepository

  init(repository: HabitRepository) {
    self.repository = repository
  }

  var canSave: Bool {
    !trimmedName.isEmpty
  }

  func save() {
    guard canSave else { return }
    repository.addHabit(name: trimmedName)
    name = ""
  }

  private var trimmedName: String {
    name.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
