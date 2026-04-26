import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.brand.ignoresSafeArea()

            VStack(spacing: 20) {
                Text("🧺")
                    .font(.system(size: 80))

                VStack(spacing: 8) {
                    Text("YellowBasket")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.black)

                    Text("Your kitchen, sorted.")
                        .font(.headline)
                        .foregroundStyle(.black.opacity(0.65))
                }

                ProgressView()
                    .tint(.black.opacity(0.45))
                    .padding(.top, 24)
            }
        }
    }
}

#Preview {
    SplashView()
}
