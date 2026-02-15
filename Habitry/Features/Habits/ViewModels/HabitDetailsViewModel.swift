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

    /// Start-of-day dates that have an entry (same calendar as list: Monday first).
    var entryDates: Set<Date> {
        let calendar = Self.calendar
        guard let entries = habit.entries as? Set<HabitEntryEntity> else { return [] }
        return Set(entries.compactMap { $0.date }.map { calendar.startOfDay(for: $0) })
    }

    static var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }

    var nameText: String {
        habit.name ?? "Name"
    }

    func makeEditViewModel() -> HabitEditViewModel {
        HabitEditViewModel(habit: habit, repository: repository)
    }

    /// Toggle entry for the given day (add with current time, or remove if exists).
    func toggleEntry(for date: Date) {
        repository.toggleEntry(habit: habit, date: date)
    }

    var totalEntriesCount: Int {
        (habit.entries as? Set<HabitEntryEntity>)?.count ?? 0
    }

    /// Sum of entry values in the given month (pass start-of-month date).
    func valueSumInMonth(_ monthStart: Date) -> Int {
        let calendar = Self.calendar
        guard let entries = habit.entries as? Set<HabitEntryEntity> else { return 0 }
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthStart) ?? monthStart
        return entries
            .filter { ($0.date ?? .distantPast) >= monthStart && ($0.date ?? .distantPast) < nextMonth }
            .reduce(0) { $0 + Int($1.value) }
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
    formatter.dateFormat = "HH:mm, dd.MM.yyyy"
    return formatter
}()
