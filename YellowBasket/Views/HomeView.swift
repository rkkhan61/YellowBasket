import SwiftUI

struct HomeView: View {

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning 👋"
        case 12..<17: return "Good afternoon 👋"
        default:      return "Good evening 👋"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Greeting
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("What's in your kitchen?")
                            .font(.title.bold())
                    }
                    .padding(.horizontal, 24)

                    // Scan CTA card — brand gradient
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Scan Ingredients")
                                    .font(.title3.bold())
                                Text("Point your camera at ingredients\nto discover recipes instantly.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "barcode.viewfinder")
                                .font(.system(size: 36))
                                .foregroundStyle(Color.brand)
                        }

                        Text("Start Scanning")
                            .font(.subheadline.bold())
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.brand, in: RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [Color.brand.opacity(0.14), Color.brand.opacity(0.04)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: 16)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.brand.opacity(0.18), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    // How it works
                    VStack(alignment: .leading, spacing: 14) {
                        Text("How it works")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 24)

                        VStack(spacing: 0) {
                            HowItWorksRow(step: "1", icon: "photo.badge.plus", text: "Choose a photo of your fridge or pantry")
                            Divider().padding(.leading, 56)
                            HowItWorksRow(step: "2", icon: "checkmark.circle", text: "Confirm the detected ingredients")
                            Divider().padding(.leading, 56)
                            HowItWorksRow(step: "3", icon: "fork.knife", text: "Get recipe suggestions instantly")
                        }
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .navigationTitle("YellowBasket")
        }
    }
}

private struct HowItWorksRow: View {
    let step: String
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.brand.opacity(0.12))
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.brand)
            }

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
    }
}

#Preview {
    HomeView()
}
