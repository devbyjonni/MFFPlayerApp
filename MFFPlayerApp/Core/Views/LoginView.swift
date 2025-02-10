//
//  LoginView.swift
//  MFFPlayerApp
//
//  Created by Jonni Akesson on 2025-02-10.
//

import SwiftUI

struct LoginView: View {
    @Environment(UserSession.self) private var userSession
    
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .bold()
                    .padding()
            }
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: login) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
    }
    
    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password are required"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            await userSession.login(username: username, password: password)
            isLoading = false
            
            if !userSession.isAuthenticated {
                errorMessage = "Invalid credentials"
            }
        }
    }
}
