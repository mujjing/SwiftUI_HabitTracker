//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by 전지훈 on 2022/10/21.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
