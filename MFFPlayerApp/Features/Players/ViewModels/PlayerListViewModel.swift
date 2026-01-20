import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class PlayerListViewModel {
    
    // MARK: - Properties
    private let modelContext: ModelContext
    private let apiService: APIServiceProtocol
    
    private(set) var isLoading = false
    var errorMessage: String?
    
    // MARK: - Initialization
    init(modelContext: ModelContext, apiService: APIServiceProtocol = APIService.shared) {
        self.modelContext = modelContext
        self.apiService = apiService
    }
    
    // MARK: - Public Methods
    
    /// Load players from database or API if necessary.
    /// Load players from database or API if necessary.
    func loadPlayers() async {
        do {
            let descriptor = FetchDescriptor<PlayerEntity>()
            let storedPlayers = try modelContext.fetch(descriptor)
            
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
    

    


    // MARK: - Private Methods
    
    private func fetchPlayersFromAPI() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let players: [Player] = try await apiService.fetchData(from: APIConfig.playersEndpoint)
            
            // Database Synchronization Logic
            let descriptor = FetchDescriptor<PlayerEntity>()
            let existingPlayers = try modelContext.fetch(descriptor)
            
            // Cache favorites
            let favoriteIds = Set(existingPlayers.filter { $0.isFavorite }.map { $0.id })
            
            // Clear existing
            for player in existingPlayers {
                modelContext.delete(player)
            }
            
            // Insert new
            for player in players {
                let playerEntity = PlayerEntity(
                    id: player.id,
                    name: player.name,
                    number: player.number,
                    image: player.image,
                    imageData: nil,
                    isFavorite: favoriteIds.contains(player.id),
                    bio: player.bio,
                    dob: player.dob,
                    position: player.position,
                    stats_games: player.stats_games,
                    stats_goals: player.stats_goals,
                    stats_assists: player.stats_assists,
                    stats_yellow: player.stats_yellow,
                    stats_red: player.stats_red
                )
                modelContext.insert(playerEntity)
            }
            try modelContext.save()
            
            // Trigger background image download
            Task {
                await downloadMissingImages()
            }
        } catch {
            handleError(error, message: "Failed to update players")
        }
    }
    
    private func downloadMissingImages() async {
        do {
            let descriptor = FetchDescriptor<PlayerEntity>()
            let players = try modelContext.fetch(descriptor)
            
            for player in players {
                guard player.imageData == nil, let url = URL(string: player.image) else { continue }
                
                print("PlayerViewModel: ⬇️ Downloading image for \(player.name)...")
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    player.imageData = data
                    try modelContext.save()
                } catch {
                     print("PlayerViewModel: ⚠️ Failed to download image for \(player.name): \(error.localizedDescription)")
                }
            }
        } catch {
            print("PlayerViewModel: ❌ Error fetching players for image download")
        }
    }
    
    private func handleError(_ error: Error, message: String) {
        errorMessage = "\(message): \(error.localizedDescription)"
        print("PlayerViewModel: ❌ \(message): \(error.localizedDescription)")
    }
}
