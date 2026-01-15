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
