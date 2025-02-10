//
//  UserSession.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-10.
//

import Foundation
import Observation

@Observable
final class UserSession {
    var isAuthenticated = false {
        didSet {
            print("🔐 Authentication State Changed: \(isAuthenticated ? "Authenticated ✅" : "Not Authenticated ❌")")
        }
    }
    
    var token: String?
    
    func login(username: String, password: String) async {
        do {
            let token = try await APIService.shared.getToken(username: username, password: password)
            if !token.isEmpty {
                self.token = token
                isAuthenticated = true
            }
        } catch {
            print("❌ Authentication failed: \(error.localizedDescription)")
        }
    }
    
    func logout() {
        print("🚪 Logging out...")
        isAuthenticated = false
        token = nil
    }
}
