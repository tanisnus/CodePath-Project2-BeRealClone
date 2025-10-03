//
//  AuthenticationManager.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//

import SwiftUI
import ParseSwift

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    init() {
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        if let user = User.current {
            isAuthenticated = true
            currentUser = user
        } else {
            isAuthenticated = false
            currentUser = nil
        }
    }
    
    func login(username: String, password: String) async throws {
        do {
            let user = try await User.login(username: username, password: password)
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.currentUser = user
            }
        } catch {
            throw error
        }
    }
    
    func register(username: String, password: String, email: String) async throws {
        do {
            var newUser = User()
            newUser.username = username
            newUser.email = email
            newUser.password = password
            
            let signedUpUser = try await newUser.signup()
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.currentUser = signedUpUser
            }
        } catch {
            throw error
        }
    }
    
    func logout() async throws {
        do {
            try await User.logout()
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.currentUser = nil
            }
        } catch {
            throw error
        }
    }
}
