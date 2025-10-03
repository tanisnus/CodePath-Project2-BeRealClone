//
//  CameraView.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//

import SwiftUI
import PhotosUI
import ParseSwift

struct CameraView: View {
    @State private var selectedImage: UIImage?
    @State private var caption = ""
    @State private var showingImagePicker = false
    @State private var isUploading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Image display
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                        .cornerRadius(10)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("Select a photo")
                                    .foregroundColor(.gray)
                            }
                        )
                }
                
                // Caption input
                TextField("Add a caption (optional)", text: $caption, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
                
                // Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Select Photo")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    if selectedImage != nil {
                        Button(action: uploadPost) {
                            HStack {
                                if isUploading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                }
                                Text("Post")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(isUploading)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .alert("Post Status", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func uploadPost() {
        guard let image = selectedImage else { return }
        
        isUploading = true
        
        Task {
            do {
                // Convert image to data
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image"])
                }
                
                // Create Parse file
                let parseFile = ParseFile(name: "post_image.jpg", data: imageData)
                let savedFile = try await parseFile.save()
                
                // Create post
                var post = Post()
                post.author = User.current
                post.image = savedFile
                post.caption = caption.isEmpty ? nil : caption
                
                // Save post
                let savedPost = try await post.save()
                
                DispatchQueue.main.async {
                    self.isUploading = false
                    self.alertMessage = "Post uploaded successfully!"
                    self.showingAlert = true
                    self.selectedImage = nil
                    self.caption = ""
                }
            } catch {
                DispatchQueue.main.async {
                    self.isUploading = false
                    self.alertMessage = "Failed to upload post: \(error.localizedDescription)"
                    self.showingAlert = true
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}
