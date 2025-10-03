//
//  FeedView.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//

import SwiftUI
import ParseSwift

struct FeedView: View {
    @State private var posts: [Post] = []
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading posts...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if posts.isEmpty {
                    VStack {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No posts yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Be the first to post!")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(posts, id: \.objectId) { post in
                                PostView(post: post)
                            }
                        }
                        .padding()
                    }
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Feed")
            .onAppear {
                loadPosts()
            }
            .refreshable {
                loadPosts()
            }
        }
    }
    
    private func loadPosts() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                let query = Post.query()
                    .include("author")
                    .order([.descending("createdAt")])
                
                let fetchedPosts = try await query.find()
                
                DispatchQueue.main.async {
                    self.posts = fetchedPosts
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load posts: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

struct PostView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Author info
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(post.author?.username ?? "Unknown")
                        .font(.headline)
                    Text(post.createdAt?.formatted(date: .abbreviated, time: .shortened) ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            // Post image
            if let imageFile = post.image {
                AsyncImage(url: imageFile.url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            ProgressView()
                        )
                }
                .cornerRadius(10)
            }
            
            // Caption
            if let caption = post.caption, !caption.isEmpty {
                Text(caption)
                    .font(.body)
                    .padding(.horizontal, 5)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}
