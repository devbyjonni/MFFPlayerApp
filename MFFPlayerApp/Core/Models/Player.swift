//
//  Player.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-07.
//

import Foundation
import SwiftData

/// Represents a domain model for a player in the app.
/// This entity is used for UI interactions and business logic,
/// separate from the API response model to ensure data integrity and flexibility.
@Model
final class PlayerEntity: Identifiable {
    /// Unique identifier for the player.
    var id: String
    
    /// Player's full name.
    var name: String
    
    /// Jersey number associated with the player.
    var number: String
    
    /// URL or file path for the player's image.
    var image: String
    
    /// Initializes a new `PlayerEntity` instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the player.
    ///   - name: Player's full name.
    ///   - number: Jersey number.
    ///   - image: URL or file path for the player's image.
    init(id: String, name: String, number: String, image: String) {
        self.id = id
        self.name = name
        self.number = number
        self.image = image
    }
}

/// Represents the API response structure for fetching player data.
/// The `players` property contains an array of `Player` objects.
struct PlayerResponse: Decodable {
    let players: [Player]
}

/// Represents a player as returned by the API.
/// This model is strictly used for network data transfer and decoding.
///
/// - Conforms to `Codable` for JSON parsing.
/// - Implements `Identifiable` to be compatible with SwiftUI lists.
struct Player: Codable, Identifiable {
    /// Unique identifier for the player, derived from their jersey number.
    var id: String { number }
    
    /// Player's full name.
    let name: String
    
    /// Jersey number assigned to the player.
    let number: String
    
    /// URL or file path of the player's image.
    let image: String
}
