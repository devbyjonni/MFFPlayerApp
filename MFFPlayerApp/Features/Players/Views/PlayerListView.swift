//
//  PlayerListView.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-07.
//

import SwiftUI
import SwiftData

struct PlayerListView: View {
    @Query(sort: \PlayerEntity.name) private var storedPlayers: [PlayerEntity]
    @State var viewModel: PlayerViewModel
    @State private var showError = false // Local state to trigger alert
    
    var body: some View {
        List(storedPlayers) { player in
            NavigationLink(destination: PlayerDetailView(player: player, viewModel: viewModel)) {
                HStack(spacing: 12) {
                    // Player Image
                    AsyncImage(url: URL(string: player.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else if phase.error != nil {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        } else {
                            ProgressView()
                                .frame(width: 50, height: 50)
                        }
                    }
                    
                    // Player Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(player.name)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        if !player.number.isEmpty {
                            Text("#\(player.number)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.checkForUpdates()
        }
        .task {
            await viewModel.loadPlayers()
        }
        // ✅ Error Handling
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if newValue != nil {
                showError = true
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
        .overlay {
            if viewModel.isLoading && storedPlayers.isEmpty {
                ProgressView("Loading players...")
            }
        }
    }
}

// PlayerCardView removed in favor of inline List row for simplicity
