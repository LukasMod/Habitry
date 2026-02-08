//
//  ContentView.swift
//  Habitry
//
//  Created by Łukasz Modzelewski on 01/02/2026.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: HabitListViewModel

    init(viewContext: NSManagedObjectContext) {
        let repository = CoreDataHabitRepository(viewContext: viewContext)
        _viewModel = StateObject(
            wrappedValue: HabitListViewModel(repository: repository)
        )
    }

    var body: some View {
        HabitListView(viewModel: viewModel)
    }
}

#Preview {
    ContentView(
        viewContext: PersistenceController.preview.container.viewContext
    )
}
