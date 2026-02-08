import CoreData

protocol HabitRepository: AnyObject {
    func startObserving(onChange: @escaping ([HabitEntity]) -> Void)
    func addDefaultHabit()
    func addHabit(name: String)
    func deleteHabits(habits: [HabitEntity])
}
