//
//  APIServiceTests.swift
//  MFFPlayerAppTests
//
//  Created by Jonni Akesson on 2025-02-13.
//

import XCTest
@testable import MFFPlayerApp

final class APIServiceTests: XCTestCase {
    
    var apiService: APIServiceProtocol!
    
    override func setUp() {
        super.setUp()
        
        // Setup configuration to use our Mock Protocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        // We'll init APIService with a custom session if we refactor APIService to accept it,
        // BUT for now, since APIService uses URLSession.shared internally, 
        // a pure Unit Test without DI is harder.
        // ADAPTATION: We will create a "NetworkManager" or modify APIService to be testable.
        // OR, we can mock the entire APIServiceProtocol in ViewModelTests (which is better).
        
        // Let's modify APIService to accept a URLSession first, to make it testable? 
        // Actually, let's keep it simple for the recruiter showcase: 
        // We will test `PlayerViewModel` using a MOCK APIService. That is cleaner.
    }
}

// MARK: - Mock API Service
class MockAPIService: APIServiceProtocol {
    var shouldFail = false
    
    func fetchData<T>(from urlString: String) async throws -> T where T : Decodable {
        if shouldFail {
            throw APIError.serverError(statusCode: 500)
        }
        
        // Return dummy data (assuming T is [Player])
        if T.self == [Player].self {
            let player = Player(name: "Test Player", number: "10", image: "img.jpg", details_url: "url")
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
            stats_games: 10,
            stats_goals: 5,
            stats_assists: 2,
            stats_yellow: 1,
            stats_red: 0
        )
    }
}
