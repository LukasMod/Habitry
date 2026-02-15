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

    /// Number of distinct days in the given month that have at least one entry.
    func checkedDaysInMonth(_ monthStart: Date) -> Int {
        let calendar = Self.calendar
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthStart) ?? monthStart
        return entryDates.filter { $0 >= monthStart && $0 < nextMonth }.count
    }

    /// Consecutive checked days ending at the most recent checked day (from today going back).
    /// Bounded by actual data: stops when we pass the earliest entry date.
    var currentStreak: Int {
        let calendar = Self.calendar
        guard let earliest = entryDates.min() else { return 0 }
        var day = calendar.startOfDay(for: Date())
        while !entryDates.contains(day) {
            day = calendar.date(byAdding: .day, value: -1, to: day)!
            if day < earliest { return 0 }
        }
        var count = 1
        var prev = calendar.date(byAdding: .day, value: -1, to: day)!
        while entryDates.contains(prev) {
            count += 1
            prev = calendar.date(byAdding: .day, value: -1, to: prev)!
        }
        return count
    }

    var currentStreakText: String {
        String(currentStreak)
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
