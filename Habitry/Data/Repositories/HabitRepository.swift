import CoreData

protocol HabitRepository: AnyObject {
    func startObserving(onChange: @escaping ([HabitEntity]) -> Void)
    func addDefaultHabit()
    func deleteHabits(habits: [HabitEntity])
}
