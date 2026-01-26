//
//  APIService.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-07.
//

import Foundation

// MARK: - API Error
enum APIError: Error, LocalizedError {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError(String)
    case networkError(Error)
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .serverError(let statusCode):
            return "Server error - Status code: \(statusCode)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized - Invalid credentials"
        }
    }
}

// MARK: - Protocol
protocol APIServiceProtocol {
    func fetchData<T: Decodable>(from urlString: String) async throws -> T
    func fetchDetails(from urlString: String, url: String) async throws -> PlayerDetails
}

// MARK: - Response Models
struct PlayerDetailsRequest: Encodable {
    let url: String
}

struct PlayerDetails: Decodable {
    let bio: String
    let dob: String
    let position: String
    
    // Stats
    let statsGames: Int
    let statsGoals: Int
    let statsAssists: Int
    let statsYellow: Int
    let statsRed: Int
    
    enum CodingKeys: String, CodingKey {
        case bio, dob, position
        case statsGames = "stats_games"
        case statsGoals = "stats_goals"
        case statsAssists = "stats_assists"
        case statsYellow = "stats_yellow"
        case statsRed = "stats_red"
    }
}

// MARK: - API Service
final class APIService: APIServiceProtocol {
    
    // MARK: - Singleton
    static let shared = APIService()
    private init() {}
    
    // MARK: - Fetch Methods
    
    /// Generic fetch method for GET requests using async/await.
    /// - Parameter urlString: The absolute URL string to fetch from.
    /// - Returns: Decoded object of type T.
    func fetchData<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                // Return server error if status is not 200 OK
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let apiError = error as? APIError { throw apiError }
            throw APIError.decodingError(error.localizedDescription)
        }
    }
    
    /// Fetches detailed player information (Bio, Stats) via POST request.
    /// - Parameters:
    ///   - urlString: Endpoint URL.
    ///   - url: The unique player URL identifier to scrape.
    /// - Returns: `PlayerDetails` object.
    func fetchDetails(from urlString: String, url: String) async throws -> PlayerDetails {
        guard let apiURL = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the body with the target player URL
        let body = PlayerDetailsRequest(url: url)
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            return try JSONDecoder().decode(PlayerDetails.self, from: data)
        } catch {
            if let apiError = error as? APIError { throw apiError }
             throw APIError.networkError(error)
        }
    }
}


