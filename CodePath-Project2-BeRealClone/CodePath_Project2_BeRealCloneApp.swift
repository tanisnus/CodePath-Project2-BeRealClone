//
//  CodePath_Project2_BeRealCloneApp.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//



import SwiftUI
import ParseSwift

@main
struct YourAppNameApp: App {
    init() {
        // Initialize Parse Swift SDK
        ParseSwift.initialize(
            applicationId: "noDwzsNbZ93oQoHKiJpdS0GgY7xtjkwUPJblAs6W",
            clientKey: "f6cJGtb304AybX3gZhySvZflMUbzz3YGmCe0GbWI",
            serverURL: URL(string: "https://parseapi.back4app.com")!
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
