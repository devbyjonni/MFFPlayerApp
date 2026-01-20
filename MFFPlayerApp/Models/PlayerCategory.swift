
import SwiftUI

enum PlayerCategory: String, CaseIterable {
    case all = "Alla"
    case goalkeeper = "Målvakt"
    case defender = "Försvarare"
    case midfielder = "Mittfältare"
    case forward = "Anfallare"
    
    // Display name for the Filter Bar (Plural)
    var filterName: String {
        switch self {
        case .all: return "Alla"
        case .goalkeeper: return "Målvakter"
        case .defender: return "Försvarare"
        case .midfielder: return "Mittfältare"
        case .forward: return "Anfallare"
        }
    }
    
    var databaseValue: String? {
        switch self {
        case .all: return nil
        case .goalkeeper: return "målvakt"
        case .defender: return "försvarare"
        case .midfielder: return "mittfältare"
        case .forward: return "anfallare"
        }
    }
    
    static func from(position: String?) -> PlayerCategory {
        guard let position = position?.lowercased() else { return .all }
        
        if position.contains("målvakt") || position.contains("goalkeeper") || position.contains("keeper") {
            return .goalkeeper
        } else if position.contains("försvar") || position.contains("defender") || position.contains("back") {
            return .defender
        } else if position.contains("mittfält") || position.contains("midfield") {
            return .midfielder
        } else if position.contains("anfall") || position.contains("forward") || position.contains("striker") {
            return .forward
        }
        return .all
    }
}
