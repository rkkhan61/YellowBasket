import SwiftUI

struct ManualIngredientEntryView: View {
    @State private var inputText = ""
    @State private var entries: [String] = []
    @State private var showConfirmation = false
    @FocusState private var focused: Bool

    private var ingredients: [Ingredient] {
        entries.map { name in
            Ingredient(id: UUID(), name: name, emoji: "🍽️", category: "Other", isSelected: true, confidence: 1.0)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Input row
                HStack(spacing: 12) {
                    TextField("e.g. Tomatoes, Chicken...", text: $inputText)
                        .focused($focused)
                        .onSubmit { addEntry() }
                        .submitLabel(.done)

                    Button("Add", action: addEntry)
                        .font(.subheadline.bold())
                        .foregroundStyle(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? Color(.systemGray3) : Color.brand)
                        .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(14)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))

                // Added ingredients list
                if !entries.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(entries.count) ingredient\(entries.count == 1 ? "" : "s") added")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)

                        VStack(spacing: 0) {
                            ForEach(entries.indices, id: \.self) { index in
                                HStack(spacing: 12) {
                                    Text("🍽️")
                                        .font(.title3)
                                        .frame(width: 36)
                                    Text(entries[index])
                                        .font(.body)
                                    Spacer()
                                    Button {
                                        entries.remove(at: index)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title3)
                                            .foregroundStyle(Color(.systemGray3))
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)

                                if index < entries.count - 1 {
                                    Divider()
                                        .padding(.leading, 62)
                                }
                            }
                        }
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                    }

                    // Continue button
                    Button {
                        focused = false
                        showConfirmation = true
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.brand, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle("Add Manually")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showConfirmation) {
            IngredientConfirmationView(ingredients: ingredients)
        }
        .onAppear { focused = true }
    }

    private func addEntry() {
        let trimmed = inputText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        entries.append(trimmed)
        inputText = ""
    }
}

#Preview {
    NavigationStack {
        ManualIngredientEntryView()
    }
}
