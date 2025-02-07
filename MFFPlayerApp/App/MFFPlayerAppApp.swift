//
//  MFFPlayerAppApp.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-07.
//

import SwiftUI
import SwiftData

@main
struct MFFPlayerAppApp: App {
    let container: ModelContainer
    private var databaseActor: DatabaseActor
    
    init() {
        do {
            container = try ModelContainer(for: PlayerEntity.self)
            databaseActor = DatabaseActor(modelContainer: container)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: PlayerViewModel(database: databaseActor))
                .modelContainer(container)
                .onAppear {
                    printDatabaseLocation()
                }
        }
    }
    
    private func printDatabaseLocation() {
        if let storeURL = container.configurations.first?.url {
            print("📂 Database is stored at: \(storeURL.path)")
        } else {
            print("❌ Failed to retrieve database location.")
        }
    }
}

