//
//  PreviewContext.swift
//  Habitry
//
//  Created for SwiftUI previews.
//

#if DEBUG
import CoreData

enum PreviewContext {
    static var viewContext: NSManagedObjectContext {
        PersistenceController.preview.container.viewContext
    }

    static var repository: HabitRepository {
        CoreDataHabitRepository(viewContext: viewContext)
    }

    /// Creates a habit entry in the same context as the habit. Use in previews to avoid repeating entry setup.
    static func makeEntry(habit: HabitEntity, date: Date = Date()) -> HabitEntryEntity {
        let context = habit.managedObjectContext ?? viewContext
        let entry = HabitEntryEntity(context: context)
        entry.id = UUID()
        entry.date = date
        entry.createdAt = date
        entry.habit = habit
        return entry
    }
}
#endif
