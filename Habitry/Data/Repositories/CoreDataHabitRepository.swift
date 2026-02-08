import CoreData

@MainActor
final class CoreDataHabitRepository: NSObject, HabitRepository {
    private let viewContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<HabitEntity>
    private var onChange: (([HabitEntity]) -> Void)?

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext

        let fetchRequest: NSFetchRequest<HabitEntity> =
            HabitEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \HabitEntity.createdAt, ascending: true)
        ]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nsError = error as NSError
            assertionFailure(
                "Failed to fetch habits \(nsError), \(nsError.userInfo)"
            )
        }
    }

    func startObserving(onChange: @escaping ([HabitEntity]) -> Void) {
        self.onChange = onChange
        onChange(fetchedResultsController.fetchedObjects ?? [])
    }

    func addDefaultHabit() {
        addHabit(name: "New Habit")
    }

    func addHabit(name: String) {
        let newItem = HabitEntity(context: viewContext)

        newItem.id = UUID()
        newItem.name = name
        newItem.unit = "unit"
        newItem.targetValue = 10
        newItem.createdAt = Date()
        newItem.isArchived = false
        newItem.reminderEnabled = false
        newItem.reminderTime = nil
        newItem.currentStreak = 0

        // create 30 habit entries for the last 30 days
        // let calendar = Calendar.current
        // let today = Date()
        // for dayOffset in 0..<30 {
        //     let entryDate = calendar.date(
        //         byAdding: .day,
        //         value: -dayOffset,
        //         to: today
        //     )!
        //     let entry = HabitEntryEntity(context: viewContext)
        //     entry.id = UUID()
        //     entry.date = entryDate
        //     entry.createdAt = entryDate
        //     entry.habit = newItem
        // }

        save()
    }

    func toggleEntry(habit: HabitEntity, date: Date) {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: date)
        let nextDay = calendar.date(byAdding: .day, value: 1, to: dayStart)
        let entries = habit.entries as? Set<HabitEntryEntity> ?? []

        if let existing = entries.first(where: { entry in
            guard let entryDate = entry.date, let nextDay else { return false }
            return entryDate >= dayStart && entryDate < nextDay
        }) {
            viewContext.delete(existing)
            save()
            return
        }

        let entry = HabitEntryEntity(context: viewContext)
        entry.id = UUID()
        entry.date = dayStart
        entry.createdAt = Date()
        entry.habit = habit

        save()
    }

    func deleteHabits(habits: [HabitEntity]) {
        for habit in habits {
            viewContext.delete(habit)
        }
        save()
    }

    private func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension CoreDataHabitRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        onChange?(fetchedResultsController.fetchedObjects ?? [])
    }
}
