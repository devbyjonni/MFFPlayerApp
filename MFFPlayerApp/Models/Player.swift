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
    var id: String { detailsUrl }
    let name: String
    let number: String
    let image: String
    let detailsUrl: String
    
    // Detailed Info (Optional, fetched on demand)
    var bio: String?
    var dob: String?
    var position: String?
    
    // Stats
    var statsGames: Int?
    var statsGoals: Int?
    var statsAssists: Int?
    var statsYellow: Int?
    var statsRed: Int?
    
    enum CodingKeys: String, CodingKey {
        case name, number, image
        case detailsUrl = "details_url"
        case bio, dob, position
        case statsGames = "stats_games"
        case statsGoals = "stats_goals"
        case statsAssists = "stats_assists"
        case statsYellow = "stats_yellow"
        case statsRed = "stats_red"
    }
}
