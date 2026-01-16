//
//  PlayerViewModelTests.swift
//  MFFPlayerAppTests
//
//  Created by Jonni Akesson on 2025-02-13.
//

import XCTest
import SwiftData
@testable import MFFPlayerApp

@MainActor
final class PlayerViewModelTests: XCTestCase {
    
    var viewModel: PlayerViewModel!
    var mockService: MockAPIService!
    var databaseManager: DatabaseManager!
    
    override func setUp() async throws {
        mockService = MockAPIService()
        
        // In-Memory DB for testing (Fast & Clean)
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: PlayerEntity.self, configurations: config)
        databaseManager = DatabaseManager(modelContainer: container)
        
        viewModel = PlayerViewModel(databaseManager: databaseManager, apiService: mockService)
    }
    
    func testLoadPlayersSuccess() async throws {
        // Given
        mockService.shouldFail = false
        
        // When
        await viewModel.loadPlayers()
        
        // Then
        XCTAssertNil(viewModel.errorMessage)
        let players = try await databaseManager.fetchPlayers()
        XCTAssertEqual(players.count, 1)
        XCTAssertEqual(players.first?.name, "Test Player")
    }
    
    func testLoadPlayersFailure() async {
        // Given
        mockService.shouldFail = true
        
        // When
        await viewModel.checkForUpdates()
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
