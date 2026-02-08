import Foundation
import Observation

@MainActor
@Observable
final class HabitListViewModel {
  private(set) var items: [HabitEntity] = []

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

  func makeCreateViewModel() -> HabitCreateViewModel {
    HabitCreateViewModel(repository: repository)
  }

  func deleteItems(offsets: IndexSet) {
    let habits = offsets.map { items[$0] }
    repository.deleteHabits(habits: habits)
  }
}
