import SwiftUI

struct LauncherView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss
    private let cols = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
        ZStack {
            Backdrop()
            VStack(spacing: 20) {
                HStack {
                    Text("Quick Launch").font(.system(size: 32, weight: .bold, design: .rounded))
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white)
                    }
                }
                if store.config.launcherItems.isEmpty {
                    Spacer()
                    Text("No apps yet.\nAdd some in Aperture.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    LazyVGrid(columns: cols, spacing: 16) {
                        ForEach(store.config.launcherItems) { item in
                            Button {
                                Launcher.open(item.urlString)
                            } label: {
                                VStack(spacing: 12) {
                                    Image(systemName: item.symbol)
                                        .font(.system(size: 38))
                                        .foregroundStyle(accentGradient)
                                    Text(item.name)
                                        .font(.system(.headline, design: .rounded))
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity, minHeight: 110)
                                .glassCard(26)
                            }
                            .buttonStyle(PressStyle())
                        }
                    }
                    Spacer()
                }
            }
            .padding(20)
        }
        .preferredColorScheme(.dark)
    }
}
