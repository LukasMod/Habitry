import Combine
import SwiftUI

@MainActor
final class HabitListViewModel: ObservableObject {
  @Published private(set) var items: [HabitEntity] = []

  private let repository: HabitRepository

  init(repository: HabitRepository) {
    self.repository = repository
    repository.startObserving { [weak self] items in
      self?.items = items
    }
  }

  func addHabit() {
    repository.addDefaultHabit()
  }

  func deleteItems(offsets: IndexSet) {
    let habits = offsets.map { items[$0] }
    repository.deleteHabits(habits: habits)
  }
}
