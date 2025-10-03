//
//  CameraView.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//


import SwiftUI

struct CameraView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Camera")
                    .font(.largeTitle)
                Text("Photo upload coming soon")
                    .foregroundColor(.gray)
            }
            .navigationTitle("Camera")
        }
    }
}