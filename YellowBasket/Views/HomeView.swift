import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Greeting
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Good morning 👋")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("What's in your kitchen?")
                            .font(.title.bold())
                    }
                    .padding(.horizontal, 24)

                    // Scan CTA card
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
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 24)
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationTitle("YellowBasket")
        }
    }
}

#Preview {
    HomeView()
}
