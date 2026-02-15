//
//  HabitDetailView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 01/02/2026.
//

import CoreData
import SwiftUI

struct HabitDetailView: View {
  @ObservedObject var habit: HabitEntity
  let viewModel: HabitDetailsViewModel
  @State private var isEditPresented = false
  @State private var displayedMonth: Date = Date()
  @Environment(\.dismiss) private var dismiss

  private var calendar: Calendar { HabitDetailsViewModel.calendar }

  init(habit: HabitEntity, viewModel: HabitDetailsViewModel) {
    self.habit = habit
    self.viewModel = viewModel
  }

  var body: some View {
    ScrollView {

      VStack(alignment: .leading, spacing: AppSpacing.m) {
        habitSummary

        habitCalendar

        Text("Entries")
          .font(.headline)

        if viewModel.entries.isEmpty {
          Text("No entries yet")
            .foregroundStyle(.secondary)
        } else {
          VStack(spacing: AppSpacing.s) {
            ForEach(viewModel.entries) { entry in
              HStack(alignment: .top, spacing: AppSpacing.s) {
                Image(systemName: "checkmark.circle.fill")
                  .foregroundStyle(.green)
                  .font(.body)
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                  Text(entry.dateText)
                    .font(.subheadline)
                  if entry.valueText != "0" {
                    Text("Value: \(entry.valueText)")
                      .font(.caption)
                      .foregroundStyle(.secondary)
                  }
                }
                Spacer(minLength: 0)
              }
              .padding(.vertical, AppSpacing.s)
              .padding(.horizontal, AppSpacing.m)
              .background(Color.gray.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
            }
          }
        }

      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(AppSpacing.m)
    }
    .navigationTitle(viewModel.nameText)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Edit") {
          isEditPresented = true
        }
      }
    }
    .sheet(isPresented: $isEditPresented) {
      HabitEditView(
        viewModel: viewModel.makeEditViewModel(),
        onDelete: {
          isEditPresented = false
          dismiss()
        }
      )
    }
  }

  private var habitCalendar: some View {
    VStack(alignment: .leading, spacing: AppSpacing.s) {
      HStack {
        Button {
          moveMonth(by: -1)
        } label: {
          Image(systemName: "chevron.left")
        }
        Spacer()
        Text(monthYearText)
          .font(.headline)
        Spacer()
        Button {
          moveMonth(by: 1)
        } label: {
          Image(systemName: "chevron.right")
        }
      }
      .padding(.horizontal, AppSpacing.xs)

      HStack(spacing: 0) {
        ForEach(weekdayLabels, id: \.self) { label in
          Text(label)
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
        }
      }

      LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
        ForEach(calendarDays, id: \.self) { cellDate in
          CalendarDayCell(
            date: cellDate,
            displayedMonthStart: calendar.startOfMonth(displayedMonth),
            calendar: calendar,
            hasEntry: viewModel.entryDates.contains(cellDate),
            onTap: { viewModel.toggleEntry(for: cellDate) }
          )
        }
      }
    }
  }

  private var habitSummary: some View {
    let monthStart = calendar.startOfMonth(displayedMonth)
    let checkedThisMonth = viewModel.checkedDaysInMonth(monthStart)
    return HStack(spacing: AppSpacing.m) {
      summaryItem(value: "\(viewModel.totalEntriesCount)", label: "Total")
      summaryItem(value: "\(checkedThisMonth)", label: "This month")
      summaryItem(value: viewModel.currentStreakText, label: "Streak")
    }
    .padding(.vertical, AppSpacing.s)
    .padding(.horizontal, AppSpacing.m)
    .background(Color.gray.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
  }

  private func summaryItem(value: String, label: String) -> some View {
    VStack(spacing: AppSpacing.xs) {
      Text(value)
        .font(.subheadline.weight(.semibold))
      Text(label)
        .font(.caption2)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity)
  }

  private var monthYearText: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    formatter.calendar = calendar
    return formatter.string(from: displayedMonth)
  }

  private var weekdayLabels: [String] {
    let symbols = calendar.veryShortWeekdaySymbols
    let first = calendar.firstWeekday - 1
    return (0..<7).map { symbols[($0 + first) % 7].prefix(1).uppercased() }
  }

  private var calendarDays: [Date] {
    let start = calendar.startOfMonth(displayedMonth)
    let weekday = calendar.component(.weekday, from: start)
    let leadingBlanks = (weekday - calendar.firstWeekday + 7) % 7
    let count = calendar.range(of: .day, in: .month, for: start)?.count ?? 31
    var out: [Date] = []
    if let prevMonth = calendar.date(byAdding: .month, value: -1, to: start) {
      let prevCount = calendar.range(of: .day, in: .month, for: prevMonth)?.count ?? 30
      for d in (prevCount - leadingBlanks + 1)...prevCount {
        if let date = calendar.date(bySetting: .day, value: d, of: prevMonth) {
          out.append(calendar.startOfDay(for: date))
        }
      }
    }
    for d in 1...count {
      if let date = calendar.date(bySetting: .day, value: d, of: start) {
        out.append(calendar.startOfDay(for: date))
      }
    }
    let remaining = 42 - out.count
    if remaining > 0, let nextMonth = calendar.date(byAdding: .month, value: 1, to: start) {
      for d in 1...remaining {
        if let date = calendar.date(bySetting: .day, value: d, of: nextMonth) {
          out.append(calendar.startOfDay(for: date))
        }
      }
    }
    return out
  }

  private func moveMonth(by delta: Int) {
    if let next = calendar.date(byAdding: .month, value: delta, to: displayedMonth) {
      displayedMonth = calendar.startOfMonth(next)
    }
  }
}

private extension Calendar {
  func startOfMonth(_ date: Date) -> Date {
    let comps = dateComponents([.year, .month], from: date)
    return self.date(from: comps) ?? date
  }
}

private struct CalendarDayCell: View {
  let date: Date
  let displayedMonthStart: Date
  let calendar: Calendar
  let hasEntry: Bool
  var onTap: (() -> Void)?

  private var dayNumber: Int { calendar.component(.day, from: date) }
  private var inMonth: Bool {
    calendar.isDate(date, equalTo: displayedMonthStart, toGranularity: .month)
  }
  private var isFuture: Bool {
    date > calendar.startOfDay(for: Date())
  }

  var body: some View {
    let isToday = calendar.isDateInToday(date)
    Button(action: { if !isFuture { onTap?() } }) {
      Text("\(dayNumber)")
        .font(.caption)
        .fontWeight(isToday ? .semibold : .regular)
        .foregroundStyle(hasEntry ? .white : (inMonth ? .primary : .secondary))
        .frame(minWidth: AppSize.daySquare + 4, minHeight: AppSize.daySquare + 4)
        .background {
          if hasEntry {
            RoundedRectangle(cornerRadius: AppSize.daySquareCornerRadius)
              .fill(Color.green)
          }
        }
        .overlay {
          if isToday && !hasEntry {
            RoundedRectangle(cornerRadius: AppSize.daySquareCornerRadius)
              .stroke(Color.accentColor, lineWidth: 2)
          } else if isToday && hasEntry {
            RoundedRectangle(cornerRadius: AppSize.daySquareCornerRadius)
              .stroke(Color.white, lineWidth: 2)
          }
        }
        .overlay {
          if isToday && hasEntry {
            RoundedRectangle(cornerRadius: AppSize.daySquareCornerRadius + 2)
              .stroke(Color.accentColor, lineWidth: 2.5)
          }
        }
    }
    .buttonStyle(.plain)
    .disabled(isFuture)
    .opacity(isFuture ? 0.5 : 1)
  }
}

#if DEBUG
#Preview("Habit details – With entries") {
  let context = PersistenceController.preview.container.viewContext
  let repository = CoreDataHabitRepository(viewContext: context)
  let habit = HabitEntity(context: context)
  habit.id = UUID()
  habit.name = "Preview Habit"
  habit.createdAt = Date()

  let calendar = Calendar.current
  for dayOffset in 0..<5 {
    if let entryDate = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) {
      _ = PreviewContext.makeEntry(habit: habit, date: entryDate)
    }
  }

  let viewModel = HabitDetailsViewModel(habit: habit, repository: repository)
  return NavigationStack {
    HabitDetailView(habit: habit, viewModel: viewModel)
  }
}

#Preview("Habit details – No entries") {
  let context = PersistenceController.preview.container.viewContext
  let repository = CoreDataHabitRepository(viewContext: context)
  let habit = HabitEntity(context: context)
  habit.id = UUID()
  habit.name = "New Habit"
  habit.createdAt = Date()
  let viewModel = HabitDetailsViewModel(habit: habit, repository: repository)
  return NavigationStack {
    HabitDetailView(habit: habit, viewModel: viewModel)
  }
}

#Preview("Habit details – Summary & calendar") {
  let context = PersistenceController.preview.container.viewContext
  let repository = CoreDataHabitRepository(viewContext: context)
  let habit = HabitEntity(context: context)
  habit.id = UUID()
  habit.name = "Running"
  habit.createdAt = Date()
  habit.currentStreak = 7
  let cal = Calendar.current
  for dayOffset in 0..<12 {
    if let d = cal.date(byAdding: .day, value: -dayOffset, to: Date()) {
      let e = PreviewContext.makeEntry(habit: habit, date: d)
      e.value = Int16(2 + dayOffset % 3)
    }
  }
  let viewModel = HabitDetailsViewModel(habit: habit, repository: repository)
  return NavigationStack {
    HabitDetailView(habit: habit, viewModel: viewModel)
  }
}
#endif
