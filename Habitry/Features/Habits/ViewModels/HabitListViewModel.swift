import SwiftUI
import Combine

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
        for index in offsets {
            repository.delete(habit: items[index])
        }
    }
}
