//
//  Player.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-07.
//

import Foundation

//// Represents the API response structure for fetching player data.

/// Represents a player as returned by the API.
struct Player: Codable, Identifiable {
    var id: String { details_url }
    let name: String
    let number: String
    let image: String
    let details_url: String
    
    // Detailed Info (Optional, fetched on demand)
    var bio: String?
    var dob: String?
    var position: String?
    
    // Stats
    var stats_games: Int?
    var stats_goals: Int?
    var stats_assists: Int?
    var stats_yellow: Int?
    var stats_red: Int?
}
