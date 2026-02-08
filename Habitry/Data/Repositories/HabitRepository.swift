import CoreData

protocol HabitRepository: AnyObject {
    func startObserving(onChange: @escaping ([HabitEntity]) -> Void)
    func addDefaultHabit()
    func addHabit(name: String)
    func toggleEntry(habit: HabitEntity, date: Date)
    func deleteHabits(habits: [HabitEntity])
}
