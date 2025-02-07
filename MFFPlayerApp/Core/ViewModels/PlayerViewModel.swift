//
//  PlayerViewModel.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-07.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class PlayerViewModel {
    private let database: DatabaseActor
    private(set) var isLoading = false
    
    init(database: DatabaseActor) {
        self.database = database
    }
    
    /// Load players from database or API if necessary
    func loadPlayers() async {
        do {
            let storedPlayers = try await database.fetchPlayers()
            if !storedPlayers.isEmpty {
                logMessage("✅ Players already exist in database, skipping fetch.")
                return
            }
            
            logMessage("⚠️ No players found in database, fetching from API...")
            await fetchAndSavePlayers()
        } catch {
            logMessage("❌ Error fetching players: \(error.localizedDescription)")
        }
    }
    /// Check for updates from API and refresh database
    func checkForUpdates() async {
        logMessage("🚀 Checking for updates from API...")
        await fetchAndSavePlayers()
    }
    /// Fetch players from API and update SwiftData
    private func fetchAndSavePlayers() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            logMessage("🔄 Fetching player data from API...")
            let playerResponse: PlayerResponse = try await APIService.shared.fetchData(from: APIConfig.urlString)
            
            try await database.clearAndSavePlayers(players: playerResponse.players)
            logMessage("✅ Successfully updated players from API.")
        } catch {
            logMessage("❌ Error updating players: \(error.localizedDescription)")
        }
    }
    /// Simple log function for debugging
    private func logMessage(_ message: String) {
        NSLog("\(message)")
    }
}

