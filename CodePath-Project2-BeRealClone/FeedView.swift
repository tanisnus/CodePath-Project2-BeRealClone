//
//  FeedView.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//


import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Feed")
                    .font(.largeTitle)
                Text("Posts will appear here")
                    .foregroundColor(.gray)
            }
            .navigationTitle("Feed")
        }
    }
}