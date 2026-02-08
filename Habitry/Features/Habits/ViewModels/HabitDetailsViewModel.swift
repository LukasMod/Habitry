import CoreData
import Foundation

@MainActor
final class HabitDetailsViewModel {
    private let habit: HabitEntity
    private let repository: HabitRepository

    init(habit: HabitEntity, repository: HabitRepository) {
        self.habit = habit
        self.repository = repository
    }

    var nameText: String {
        habit.name ?? "Name"
    }

    func makeEditViewModel() -> HabitEditViewModel {
        HabitEditViewModel(habit: habit, repository: repository)
    }

    var currentStreakText: String {
        String(habit.currentStreak)
    }

    var longestStreakText: String {
        String(habit.longestStreak)
    }

    var createdAtText: String {
        dateFormatter.string(from: habit.createdAt ?? Date())
    }

    var isArchivedText: String {
        String(habit.isArchived)
    }

    var targetValueText: String {
        String(habit.targetValue)
    }

    var unitText: String {
        habit.unit ?? "Unit"
    }

    var entries: [HabitEntryRow] {
        guard let entries = habit.entries as? Set<HabitEntryEntity> else {
            return []
        }

        let sorted = entries.sorted { lhs, rhs in
            (lhs.date ?? .distantPast) > (rhs.date ?? .distantPast)
        }

        return sorted.enumerated().map { index, entry in
            HabitEntryRow(
                id: entry.objectID,
                index: index,
                dateText: dateFormatter.string(from: entry.date ?? Date()),
                valueText: String(entry.value)
            )
        }
    }
}

struct HabitEntryRow: Identifiable {
    let id: NSManagedObjectID
    let index: Int
    let dateText: String
    let valueText: String
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
