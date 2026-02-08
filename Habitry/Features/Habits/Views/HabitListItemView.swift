//
//  HabitListItemView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 08/02/2026.
//

import SwiftUI

struct HabitListItemView: View {
    @ObservedObject var habit: HabitEntity
    let onToggleCheckIn: () -> Void

    var body: some View {
        HabitListItemContentView(
            name: habit.name ?? "Name",
            entryDates: entryDays,
            onToggleCheckIn: onToggleCheckIn
        )
    }

    private var entryDays: Set<Date> {
        let calendar = Self.makeCalendar()
        let entries = habit.entries as? Set<HabitEntryEntity> ?? []
        return Set(
            entries.compactMap { $0.date }.map { calendar.startOfDay(for: $0) }
        )
    }

    private static func makeCalendar() -> Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }
}

private struct HabitListItemContentView: View {
    let name: String
    let entryDates: Set<Date>
    let onToggleCheckIn: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.m) {
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                Text(name)
                    .font(.headline)

                HStack(spacing: AppSpacing.s) {
                    ForEach(weekDays) { day in
                        WeekDayView(day: day)
                    }
                }
            }

            Spacer()

            Button(isCheckedToday ? "Done" : "Check In") {
                onToggleCheckIn()
            }
            .buttonStyle(.borderedProminent)
            .tint(isCheckedToday ? .green : .blue)
        }
        .padding(.vertical, AppSpacing.s)
    }

    private var isCheckedToday: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return entryDates.contains(today)
    }

    private var weekDays: [WeekDay] {
        let calendar = makeCalendar()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()

        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) else {
                return nil
            }
            let isChecked = entryDates.contains(calendar.startOfDay(for: date))
            
            return WeekDay(
                date: date,
                label: date.formatted(.dateTime.weekday(.narrow)).uppercased(),
                isChecked: isChecked
            )
        }
    }

    private func makeCalendar() -> Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }
}

private struct WeekDay: Identifiable {
    let date: Date
    let label: String
    let isChecked: Bool

    var id: Date { date }
}

private struct WeekDayView: View {
    let day: WeekDay

    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(day.label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize()

            RoundedRectangle(cornerRadius: AppSize.daySquareCornerRadius)
                .fill(day.isChecked ? Color.green : Color.gray.opacity(0.3))
                .frame(width: AppSize.daySquare, height: AppSize.daySquare)
                .overlay {
                    if day.isChecked {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            
        
        }
    }
}

#Preview("Habit list items") {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today

    VStack(alignment: .leading, spacing: AppSpacing.m) {
        HabitListItemContentView(name: "No entries", entryDates: [], onToggleCheckIn: {})
        HabitListItemContentView(name: "Checked today", entryDates: [today], onToggleCheckIn: {})
        HabitListItemContentView(name: "Mixed", entryDates: [today, yesterday], onToggleCheckIn: {})
    }
    .padding(AppSpacing.m)
}
