//
//  ProfileView.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Profile header
                VStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                    
                    Text(authManager.currentUser?.username ?? "User")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(authManager.currentUser?.email ?? "")
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
                
                Spacer()
                
                // Logout button
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Log Out")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
            .navigationTitle("Profile")
            .alert("Log Out", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    Task {
                        do {
                            try await authManager.logout()
                        } catch {
                            print("Logout error: \(error)")
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}
