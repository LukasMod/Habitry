//
//  HabitryApp.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 01/02/2026.
//

import SwiftUI
import CoreData

@main
struct HabitryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(
                viewContext: persistenceController.container.viewContext
            )
            .environment(
                \.managedObjectContext,
                persistenceController.container.viewContext
            )
        }
    }
}
