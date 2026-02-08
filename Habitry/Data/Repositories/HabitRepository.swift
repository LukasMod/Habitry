import CoreData

protocol HabitRepository: AnyObject {
    func startObserving(onChange: @escaping ([HabitEntity]) -> Void)
    func addDefaultHabit()
    func delete(habit: HabitEntity)
}
