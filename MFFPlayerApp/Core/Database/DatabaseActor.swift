//
//  DatabaseActor.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-08.
//

import SwiftData

@ModelActor
public actor DatabaseActor {
    func fetchPlayers() async throws -> [PlayerEntity] {
        return try modelContext.fetch(FetchDescriptor<PlayerEntity>())
    }
    /// Save new players and clear old ones to SwiftData
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
}
