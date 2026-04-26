import SwiftUI
import PhotosUI
import UIKit

struct ScanView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isAnalyzing = false
    @State private var showConfirmation = false
    @State private var detectedIngredients: [Ingredient] = []
    @State private var detectionError: String?
    @State private var showCamera = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    if let image = selectedImage {
                        imagePreview(image)
                    } else {
                        emptyState
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .navigationTitle("Scan")
            .navigationDestination(isPresented: $showConfirmation) {
                IngredientConfirmationView(ingredients: detectedIngredients)
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    guard let newItem else { return }
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        detectionError = nil
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker(image: $selectedImage, onImagePicked: { detectionError = nil })
            }
        }
    }

    // MARK: - Image Preview

    @ViewBuilder
    private func imagePreview(_ image: UIImage) -> some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .overlay(
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .allowsHitTesting(false)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)

            if isAnalyzing {
                VStack(spacing: 14) {
                    ProgressView()
                        .scaleEffect(1.3)
                    Text("Analyzing ingredients...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                VStack(spacing: 4) {
                    Text("Photo ready")
                        .font(.headline)
                    Text("Tap Continue to detect your ingredients.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 12) {
                    Button {
                        isAnalyzing = true
                        detectionError = nil
                        Task {
                            do {
                                let ingredients = try await GeminiService.shared.detectIngredients(from: image)
                                detectedIngredients = ingredients
                                showConfirmation = true
                            } catch {
                                detectionError = error.localizedDescription
                            }
                            isAnalyzing = false
                        }
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.brand, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(PressableButtonStyle())

                    HStack(spacing: 20) {
                        Button {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) { showCamera = true }
                        } label: {
                            Text("Take Photo")
                                .font(.subheadline)
                                .foregroundStyle(Color.brand)
                        }

                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text("Choose Photo")
                                .font(.subheadline)
                                .foregroundStyle(Color.brand)
                        }
                    }

                    if let error = detectionError {
                        Text(error)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)

                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 44))
                        .foregroundStyle(Color.brand)

                    VStack(spacing: 4) {
                        Text("No photo selected")
                            .font(.headline)
                        Text("Choose a fridge or pantry photo\nto detect ingredients.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding(.horizontal, 24)

            HStack(spacing: 12) {
                Button {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) { showCamera = true }
                } label: {
                    Label("Take Photo", systemImage: "camera.fill")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.brand, in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(PressableButtonStyle())

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Library", systemImage: "photo.badge.plus")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Camera picker

private struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let onImagePicked: () -> Void
    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let picked = info[.originalImage] as? UIImage {
                parent.image = picked
                parent.onImagePicked()
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    ScanView()
}
