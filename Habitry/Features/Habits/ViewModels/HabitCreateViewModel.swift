//
//  HabitCreateViewModel.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import Combine
import SwiftUI

@MainActor
final class HabitCreateViewModel: ObservableObject {
  @Published var name: String = ""

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
