//
//  Persistence.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 01/02/2026.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let habitNames = [
            ("Morning Run", "km", 5, false),
            ("Read Books", "pages", 20, false),
            ("Meditation", "minutes", 10, false),
            ("Water Intake", "glasses", 8, true),
            ("Push-ups", "reps", 50, false),
        ]

        let calendar = Calendar.current
        let today = Date()

        for (index, (name, unit, target, isArchived)) in habitNames.enumerated()
        {
            let habit = HabitEntity(context: viewContext)
            habit.id = UUID()
            habit.name = name
            habit.unit = unit
            habit.targetValue = Int16(target)
            habit.createdAt = calendar.date(
                byAdding: .day,
                value: -30 + index,
                to: today
            )
            habit.isArchived = false

            // Create streak data
            let currentStreak = Int16.random(in: 0...15)
            let longestStreak = Int16.random(in: currentStreak...20)
            habit.currentStreak = currentStreak
            habit.longestStreak = longestStreak

            // Create entries for the last 30 days
            for dayOffset in 0..<30 {
                guard
                    let entryDate = calendar.date(
                        byAdding: .day,
                        value: -dayOffset,
                        to: today
                    )
                else {
                    continue
                }

                // Randomly complete entries (higher chance for recent days)
                let completionChance = dayOffset < 7 ? 0.8 : 0.6
                let isCompleted = Double.random(in: 0...1) < completionChance

                if isCompleted {
                    let entry = HabitEntryEntity(context: viewContext)
                    entry.id = UUID()
                    entry.date = entryDate
                    entry.createdAt = entryDate
                    entry.isCompleted = true
                    entry.value = Int16.random(
                        in: Int16(target / 2)...Int16(target)
                    )

                    entry.habit = habit

                }
            }
        }

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Habitry")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(
                fileURLWithPath: "/dev/null"
            )
        }
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
