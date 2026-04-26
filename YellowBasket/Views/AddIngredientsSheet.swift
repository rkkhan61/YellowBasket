import SwiftUI

struct AddIngredientsSheet: View {
    let onImageScan: () -> Void
    @State private var showManual = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Add Ingredients")
                        .font(.title2.bold())
                    Text("How would you like to add ingredients?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)

                OptionCard(
                    emoji: "📸",
                    title: "Image Scan (AI)",
                    subtitle: "Take or choose a photo — we'll detect your ingredients automatically.",
                    action: onImageScan
                )

                OptionCard(
                    emoji: "✍️",
                    title: "Add Manually",
                    subtitle: "Type your ingredients one by one.",
                    action: { showManual = true }
                )

                Spacer()
            }
            .padding(.horizontal, 24)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .navigationDestination(isPresented: $showManual) {
                ManualIngredientEntryView()
            }
        }
    }
}

// MARK: - Option card

private struct OptionCard: View {
    let emoji: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.system(size: 34))
                    .frame(width: 60, height: 60)
                    .background(Color.brand.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color(.systemGray3))
            }
            .padding(18)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    AddIngredientsSheet(onImageScan: {})
}
