import Foundation
import Observation

@MainActor
@Observable
final class PlayerViewModel {
    private let databaseManager: DatabaseManager
    private(set) var isLoading = false
    private let userSession: UserSession
    
    
    init(databaseManager: DatabaseManager, userSession: UserSession) {
        self.databaseManager = databaseManager
        self.userSession = userSession  // ✅ Store reference
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
            await authenticateAndFetchPlayers()
        } catch {
            logMessage("❌ Error fetching players: \(error.localizedDescription)")
        }
    }
    
    /// Check for updates from API and refresh database
    func checkForUpdates() async {
        logMessage("🚀 Checking for updates from API...")
        await authenticateAndFetchPlayers()
    }
    
    /// Authenticate and fetch player data
    private func authenticateAndFetchPlayers() async {
        
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            // ✅ Ensure user is authenticated
            guard userSession.isAuthenticated else {
                logMessage("❌ User is not authenticated. Redirecting to login.")
                return
            }
            
            logMessage("🔄 Fetching player data from API...")
            
            // ✅ Use stored JWT token from UserSession
            guard let token = userSession.token else {
                logMessage("❌ Missing authentication token.")
                return
            }
            
            let playerResponse: PlayerResponse = try await APIService.shared.fetchData(from: APIConfig.playersEndpoint, token: token)
            
            try await databaseManager.clearAndSavePlayers(players: playerResponse.players)
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
