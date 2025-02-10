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
    
    var body: some View {
        NavigationView {
            List(storedPlayers) { player in
                HStack {
                    AsyncImage(url: URL(string: player.image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(player.name)
                            .font(.headline)
                        Text("#\(player.number)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("MFF Players")
            .refreshable {
                await viewModel.checkForUpdates()
            }
            .task {
                await viewModel.loadPlayers()
            }
        }
    }
}
