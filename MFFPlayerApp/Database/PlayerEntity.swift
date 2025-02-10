//
//  PlayerEntity.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-10.
//

import Foundation
import SwiftData

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
