//
//  ContentView.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//

import SwiftUI
import ParseSwift

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                AuthenticationView()
            }
        }
        .environmentObject(authManager)
    }
}

#Preview {
    ContentView()
}
