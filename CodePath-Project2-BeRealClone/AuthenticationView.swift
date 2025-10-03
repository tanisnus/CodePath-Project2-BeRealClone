//
//  AuthenticationView.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//


import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var isLoginMode = true
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // App Logo/Title
                VStack {
                    Image(systemName: "camera.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("BeReal Clone")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.top, 50)
                
                Spacer()
                
                // Authentication Form
                VStack(spacing: 15) {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    if !isLoginMode {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: handleAuthentication) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                            Text(isLoginMode ? "Log In" : "Sign Up")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(isLoading || username.isEmpty || password.isEmpty)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Toggle between login and signup
                Button(action: {
                    isLoginMode.toggle()
                    errorMessage = ""
                }) {
                    Text(isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Log In")
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    private func handleAuthentication() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                if isLoginMode {
                    try await authManager.login(username: username, password: password)
                } else {
                    try await authManager.register(username: username, password: password, email: email)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}