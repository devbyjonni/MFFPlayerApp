//
//  PlayerEntity.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-10.
//

import Foundation
import SwiftData

@Model
final class PlayerEntity: Identifiable, Hashable {
    /// Unique identifier for the player.
    var id: String
    
    /// Player's full name.
    var name: String
    
    /// Jersey number associated with the player.
    var number: String
    
    /// URL or file path for the player's image.
    var image: String
    
    /// Stored binary data for the image (for offline use).
    @Attribute(.externalStorage) // Store large data externally to keep DB fast
    var imageData: Data?
    
    /// Whether the player is marked as a favorite.
    var isFavorite: Bool = false
    
    /// Whether the player is currently in the spotlight.
    var isSpotlight: Bool = false
    
    // Details
    var bio: String?
    var dob: String?
    var position: String?
    
    // Stats
    var stats_games: Int?
    var stats_goals: Int?
    var stats_assists: Int?
    var stats_yellow: Int?
    var stats_red: Int?
    
    /// Initializes a new `PlayerEntity` instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the player.
    ///   - name: Player's full name.
    ///   - number: Jersey number.
    ///   - image: URL or file path for the player's image.
    init(id: String, name: String, number: String, image: String, imageData: Data? = nil, isFavorite: Bool = false, isSpotlight: Bool = false,
         bio: String? = nil, dob: String? = nil, position: String? = nil,
         stats_games: Int? = nil, stats_goals: Int? = nil, stats_assists: Int? = nil,
         stats_yellow: Int? = nil, stats_red: Int? = nil) {
        self.id = id
        self.name = name
        self.number = number
        self.image = image
        self.imageData = imageData
        self.isFavorite = isFavorite
        self.isSpotlight = isSpotlight
        self.bio = bio
        self.dob = dob
        self.position = position
        self.stats_games = stats_games
        self.stats_goals = stats_goals
        self.stats_assists = stats_assists
        self.stats_yellow = stats_yellow
        self.stats_red = stats_red
    }

    // MARK: - Hashable & Equatable
    // Required for NavigationLink(value:)
    static func == (lhs: PlayerEntity, rhs: PlayerEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
