import SwiftUI
import PhotosUI

struct ScanView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isAnalyzing = false
    @State private var showConfirmation = false

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
                IngredientConfirmationView()
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    guard let newItem else { return }
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }
    }

    // MARK: - Image Preview

    @ViewBuilder
    private func imagePreview(_ image: UIImage) -> some View {
        VStack(spacing: 20) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .allowsHitTesting(false)   // prevents overflow hit area blocking buttons below
                .padding(.horizontal, 24)

            VStack(spacing: 4) {
                Text("Photo ready")
                    .font(.headline)
                Text("Tap continue to detect your ingredients.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                Button {
                    isAnalyzing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isAnalyzing = false
                        showConfirmation = true
                    }
                } label: {
                    ZStack {
                        Text("Continue")
                            .font(.headline)
                            .opacity(isAnalyzing ? 0 : 1)

                        HStack(spacing: 8) {
                            ProgressView()
                                .tint(.black)
                                .scaleEffect(0.85)
                            Text("Analyzing ingredients...")
                                .font(.headline)
                        }
                        .opacity(isAnalyzing ? 1 : 0)
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.brand, in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(PressableButtonStyle())
                .disabled(isAnalyzing)

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text("Choose a different photo")
                        .font(.subheadline)
                        .foregroundStyle(Color.brand)
                }
                .disabled(isAnalyzing)
            }
            .padding(.horizontal, 24)
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

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Choose Photo", systemImage: "photo.badge.plus")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.brand, in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(PressableButtonStyle())
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    ScanView()
}
