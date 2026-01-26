//
//  MockAPIService.swift
//  MFFPlayerAppTests
//
//  Created by Jonni Akesson on 2025-02-13.
//

import Foundation
@testable import MFFPlayerApp

// MARK: - Mock API Service
// Note: No 'import XCTest' here so it is safe if accidentally added to App Target
class MockAPIService: APIServiceProtocol {
    var shouldFail = false
    
    func fetchData<T>(from urlString: String) async throws -> T where T : Decodable {
        if shouldFail {
            throw APIError.serverError(statusCode: 500)
        }
        
        // Return dummy data (assuming T is [Player])
        if T.self == [Player].self {
            let player = Player(name: "Test Player", number: "10", image: "img.jpg", detailsUrl: "url")
            return [player] as! T
        }
        
        throw APIError.decodingError("Type mismatch")
    }
    
    func fetchDetails(from urlString: String, url: String) async throws -> PlayerDetails {
        if shouldFail {
            throw APIError.serverError(statusCode: 500)
        }
        return PlayerDetails(
            bio: "Test Bio", 
            dob: "1990-01-01", 
            position: "Forward",
            statsGames: 10,
            statsGoals: 5,
            statsAssists: 2,
            statsYellow: 1,
            statsRed: 0
        )
    }
}
