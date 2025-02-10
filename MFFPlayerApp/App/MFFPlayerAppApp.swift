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
    private var databaseManager: DatabaseManager
    @State private var userSession = UserSession()
    
    init() {
        do {
            container = try ModelContainer(for: PlayerEntity.self)
            databaseManager = DatabaseManager(modelContainer: container)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                VStack {
                    if userSession.isAuthenticated {
                        PlayerListView(viewModel: PlayerViewModel(databaseManager: databaseManager, userSession: userSession))
                            .modelContainer(container)
                            .environment(userSession)
                    } else {
                        LoginView()
                            .environment(userSession)
                    }
                }
                .navigationTitle("MFF Players")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    printDatabaseLocation()
                }
                .toolbar {
                    if userSession.isAuthenticated {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: logout) {
                                Text("Logout")
                                    .foregroundColor(.blue)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    private func logout() {
        userSession.logout()
    }
    
    private func printDatabaseLocation() {
        if let storeURL = container.configurations.first?.url {
            print("📂 Database is stored at: \(storeURL.path)")
        } else {
            print("❌ Failed to retrieve database location.")
        }
    }
}
