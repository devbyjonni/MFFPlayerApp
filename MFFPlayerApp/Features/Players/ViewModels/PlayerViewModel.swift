import Foundation
import Observation

@MainActor
@Observable
final class PlayerViewModel {
    private let databaseManager: DatabaseManager
    private let apiService: APIServiceProtocol
    private(set) var isLoading = false
    var errorMessage: String?
    
    // Default to APIService.shared for convenience, but allow injection for tests
    init(databaseManager: DatabaseManager, apiService: APIServiceProtocol = APIService.shared) {
        self.databaseManager = databaseManager
        self.apiService = apiService
    }
    
    /// Load players from database or API if necessary
    func loadPlayers() async {
        do {
            let storedPlayers = try await databaseManager.fetchPlayers()
            if !storedPlayers.isEmpty {
                logMessage("✅ Players already exist in database, skipping fetch.")
                return
            }
            
            logMessage("⚠️ No players found in database, fetching from API...")
            await fetchPlayersFromAPI()
        } catch {
            errorMessage = "Failed to load players: \(error.localizedDescription)"
            logMessage("❌ Error fetching players: \(error.localizedDescription)")
        }
    }
    
    /// Check for updates from API and refresh database
    func checkForUpdates() async {
        logMessage("🚀 Checking for updates from API...")
        await fetchPlayersFromAPI()
    }
    
    /// Fetch detailed info for a specific player (Entity)
    func fetchDetails(for player: PlayerEntity) async {
        guard player.bio == nil else { return } // Already have details
        
        do {
            logMessage("🔍 Fetching details for \(player.name)...")
            
            // PlayerEntity.id IS the details_url
            let details: PlayerDetails = try await apiService.fetchDetails(from: APIConfig.detailsEndpoint, url: player.id)
            
            // Update the player in the database
            try await databaseManager.updatePlayerDetails(
                id: player.id, 
                bio: details.bio, 
                dob: details.dob, 
                position: details.position,
                stats_games: details.stats_games,
                stats_goals: details.stats_goals,
                stats_assists: details.stats_assists,
                stats_yellow: details.stats_yellow,
                stats_red: details.stats_red
            )
            
            // Force UI refresh isn't strictly needed for the detail view if it observes the same object, 
            // but refreshing the list ensures consistency. 
            // However, with SwiftData/CoreData, modifying the object should update the view automatically if observed.
            // But since we are inside an Actor (DatabaseManager) and referencing an Entity on the MainActor (View), 
            // we rely on the Actor to save contexts.
            
            logMessage("✅ details loaded for \(player.name)")
        } catch {
             logMessage("❌ Error fetching details: \(error.localizedDescription)")
        }
    }

    /// Fetch player data from API
    private func fetchPlayersFromAPI() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            logMessage("🔄 Fetching player data from API...")
            
            // ✅ Fetch [Player] directly (no wrapper)
            let players: [Player] = try await apiService.fetchData(from: APIConfig.playersEndpoint)
            
            try await databaseManager.clearAndSavePlayers(players: players)
            logMessage("✅ Successfully updated players from API.")
        } catch {
            errorMessage = "Failed to update: \(error.localizedDescription)"
            logMessage("❌ Error updating players: \(error.localizedDescription)")
        }
    }
    
    /// Simple log function for debugging
    private func logMessage(_ message: String) {
        // Using print for now, willing to upgrade to Logger later
        print("PlayerViewModel: \(message)")
    }
}
