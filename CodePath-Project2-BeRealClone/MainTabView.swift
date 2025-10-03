//
//  MainTabView.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//


//
//  MainTabView.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Feed")
                }
            
            CameraView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}