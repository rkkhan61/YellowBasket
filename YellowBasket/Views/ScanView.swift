import SwiftUI

struct ScanView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.brand.opacity(0.1))
                            .frame(width: 100, height: 100)
                        Image(systemName: "barcode.viewfinder")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.brand)
                    }

                    VStack(spacing: 8) {
                        Text("Scan Ingredients")
                            .font(.title2.bold())
                        Text("Scan your fridge and pantry\nto find matching recipes.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()
            }
            .navigationTitle("Scan")
        }
    }
}

#Preview {
    ScanView()
}
