//
//  ContentView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 01/02/2026.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \HabitEntity.createdAt, ascending: true)
        ],
        animation: .default
    )
    private var items: FetchedResults<HabitEntity>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        HabitDetailView(habit: item)
                    } label: {
                        Text(item.name ?? "Name")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = HabitEntity(context: viewContext)

            newItem.id = UUID()
            newItem.name = "New Habit"
            newItem.unit = "unit"
            newItem.targetValue = 10
            newItem.createdAt = Date()
            newItem.isArchived = false
            newItem.reminderEnabled = false
            newItem.reminderTime = nil
            newItem.currentStreak = 0

            //create 30 habit entries for the last 30 days
            let calendar = Calendar.current
            let today = Date()
            for dayOffset in 0..<30 {
                let entryDate = calendar.date(
                    byAdding: .day,
                    value: -dayOffset,
                    to: today
                )!
                let entry = HabitEntryEntity(context: viewContext)
                entry.id = UUID()
                entry.date = entryDate
                entry.createdAt = entryDate
                entry.habit = newItem
            }

            saveItems()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            viewContext.delete(items[index])
            saveItems()
        }
    }

    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// create screen with details of the habit and its entries
struct HabitDetailView: View {
    var habit: HabitEntity
    var body: some View {
        ScrollView {

            Text("Habit Detail")
            Text("Name: \(habit.name ?? "Name")")
            Text("Current Streak: \(String(habit.currentStreak))")
            Text("Longest Streak: \(String(habit.longestStreak))")
            Text(
                "Created At: \(dateFormatter.string(from: habit.createdAt ?? Date()))"
            )
            Text("Is Archived: \(String(habit.isArchived))")
            Text("Target Value: \(String(habit.targetValue))")
            Text("Unit: \(String(habit.unit ?? "Unit"))")
            Text("Entries:")
            if let entries = habit.entries as? Set<HabitEntryEntity>,
                !entries.isEmpty
            {
                ForEach(Array(entries.enumerated()), id: \.element.id) {
                    index,
                    entry in
                    HStack {
                        Text("index: \(index)")
                        Text(
                            "Date: \(dateFormatter.string(from: entry.date ?? Date()))"
                        )
                        Text("Value: \(String(entry.value))")
                        Spacer()
                    }
                }
            } else {
                Text("No Entries")
            }
        }
        //      .padding(20)
    }
}

#Preview {
    ContentView().environment(
        \.managedObjectContext,
        PersistenceController.preview.container.viewContext
    )
}
