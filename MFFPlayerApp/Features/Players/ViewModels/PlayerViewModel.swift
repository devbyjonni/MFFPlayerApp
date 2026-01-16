import Foundation
import Observation

@MainActor
@Observable
final class PlayerViewModel {
    
    // MARK: - Properties
    private let databaseManager: DatabaseManager
    private let apiService: APIServiceProtocol
    
    private(set) var isLoading = false
    var errorMessage: String?
    
    // MARK: - Initialization
    init(databaseManager: DatabaseManager, apiService: APIServiceProtocol = APIService.shared) {
        self.databaseManager = databaseManager
        self.apiService = apiService
    }
    
    // MARK: - Public Methods
    
    /// Load players from database or API if necessary.
    func loadPlayers() async {
        do {
            let storedPlayers = try await databaseManager.fetchPlayers()
            if !storedPlayers.isEmpty {
                return
            }
            
            await fetchPlayersFromAPI()
        } catch {
            handleError(error, message: "Failed to load players")
        }
    }
    
    /// Force refresh from API.
    func checkForUpdates() async {
        await fetchPlayersFromAPI()
    }
    
    /// Fetch detailed info for a specific player (Entity) on demand.
    func fetchDetails(for player: PlayerEntity) async {
        guard player.bio == nil else { return } // Cache check
        
        do {
            let details: PlayerDetails = try await apiService.fetchDetails(from: APIConfig.detailsEndpoint, url: player.id)
            
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
        } catch {
             print("PlayerViewModel: ❌ Error fetching details: \(error.localizedDescription)")
        }
    }

    // MARK: - Private Methods
    
    private func fetchPlayersFromAPI() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let players: [Player] = try await apiService.fetchData(from: APIConfig.playersEndpoint)
            try await databaseManager.clearAndSavePlayers(players: players)
        } catch {
            handleError(error, message: "Failed to update players")
        }
    }
    
    private func handleError(_ error: Error, message: String) {
        errorMessage = "\(message): \(error.localizedDescription)"
        print("PlayerViewModel: ❌ \(message): \(error.localizedDescription)")
    }
}
