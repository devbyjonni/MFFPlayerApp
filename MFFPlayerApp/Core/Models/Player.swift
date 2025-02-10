//
//  Player.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-07.
//

import Foundation

//// Represents the API response structure for fetching player data.
struct PlayerResponse: Decodable {
    let players: [Player]
}

/// Represents a player as returned by the API.
struct Player: Codable, Identifiable {
    var id: String { number }
    let name: String
    let number: String
    let image: String
}
