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
    @State private var dataLoader: PlayerListViewModel
    
    init() {
        do {
            container = try ModelContainer(for: PlayerEntity.self)
            _dataLoader = State(initialValue: PlayerListViewModel(modelContext: container.mainContext))
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                VStack {
                    PlayerListView()
                        .modelContainer(container)
                        .navigationDestination(for: PlayerEntity.self) { player in
                            PlayerDetailView(player: player)
                        }
                }
                .navigationTitle("MFF Players")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    await dataLoader.loadPlayers()
                }
            }
            .onAppear(perform: printDatabaseLocation)
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
