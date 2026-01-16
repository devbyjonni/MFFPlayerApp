//
//  APIService.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-07.
//

import Foundation

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

protocol APIServiceProtocol {
    func fetchData<T: Decodable>(from urlString: String) async throws -> T
    func fetchDetails(from urlString: String, url: String) async throws -> PlayerDetails
}

// Response Models
struct PlayerDetailsRequest: Encodable {
    let url: String
}

struct PlayerDetails: Decodable {
    let bio: String
    let dob: String
    let position: String
    
    // Stats
    let stats_games: Int
    let stats_goals: Int
    let stats_assists: Int
    let stats_yellow: Int
    let stats_red: Int
}

final class APIService: APIServiceProtocol {
    static let shared = APIService()
    private init() {}
    
    /// Fetch Data (No Auth)
    func fetchData<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Auth removed
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                // If 401 happened, it would mean server still requires auth, but we assume it's public now
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error.localizedDescription)
        }
    }
    
    /// Fetch Details (POST)
    func fetchDetails(from urlString: String, url: String) async throws -> PlayerDetails {
        guard let apiURL = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = PlayerDetailsRequest(url: url)
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            return try JSONDecoder().decode(PlayerDetails.self, from: data)
        } catch {
             throw APIError.networkError(error)
        }
    }
}


