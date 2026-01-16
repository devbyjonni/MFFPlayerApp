//
//  DatabaseManager.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-08.
//

import Foundation
import SwiftData

@ModelActor
public actor DatabaseManager {
    func fetchPlayers() async throws -> [PlayerEntity] {
        return try modelContext.fetch(FetchDescriptor<PlayerEntity>())
    }

    func clearAndSavePlayers(players: [Player]) async throws {
        let existingPlayers = try modelContext.fetch(FetchDescriptor<PlayerEntity>())
        for player in existingPlayers {
            modelContext.delete(player)
        }
        
        for player in players {
            let playerEntity = PlayerEntity(
                id: player.id,
                name: player.name,
                number: player.number,
                image: player.image
            )
            modelContext.insert(playerEntity)
        }
        try modelContext.save()
    }
    
    func updatePlayerDetails(id: String, bio: String, dob: String, position: String,
                             stats_games: Int, stats_goals: Int, stats_assists: Int,
                             stats_yellow: Int, stats_red: Int) async throws {
        let descriptor = FetchDescriptor<PlayerEntity>(predicate: #Predicate { $0.id == id })
        if let entity = try modelContext.fetch(descriptor).first {
             entity.bio = bio
             entity.dob = dob
             entity.position = position
             
             entity.stats_games = stats_games
             entity.stats_goals = stats_goals
             entity.stats_assists = stats_assists
             entity.stats_yellow = stats_yellow
             entity.stats_red = stats_red
             
             try modelContext.save()
        }
    }
}
