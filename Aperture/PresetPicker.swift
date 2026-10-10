import SwiftUI
import UIKit

struct PresetPicker: View {
    @Environment(\.dismiss) private var dismiss
    var onPick: (LaunchItem) -> Void

    @State private var customName = ""
    @State private var customScheme = ""
    private let cols = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    private func installed(_ item: LaunchItem) -> Bool {
        guard let url = URL(string: item.urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    var body: some View {
        ZStack {
            Backdrop()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Choose an app").font(.system(size: 26, weight: .bold, design: .rounded))
                    Text("Dimmed apps don't look installed, but you can still pick them.")
                        .font(.footnote).foregroundStyle(.secondary)

                    LazyVGrid(columns: cols, spacing: 12) {
                        ForEach(Presets.all) { item in
                            Button {
                                onPick(item); dismiss()
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: item.symbol).font(.title2)
                                        .foregroundStyle(accentGradient)
                                    Text(item.name).font(.caption).lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                                .glassCard(18)
                                .opacity(installed(item) ? 1 : 0.45)
                            }
                            .buttonStyle(PressStyle())
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Custom URL scheme").font(.headline)
                        TextField("Name", text: $customName)
                        TextField("Scheme, e.g. myapp://", text: $customScheme)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        Button {
                            let s = customScheme.trimmingCharacters(in: .whitespaces)
                            guard !s.isEmpty else { return }
                            let url = s.contains(":") ? s : s + "://"
                            let name = customName.isEmpty ? s : customName
                            onPick(LaunchItem(name: name, symbol: "app.fill", urlString: url))
                            dismiss()
                        } label: {
                            Text("Add custom app").bold().frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                    }
                    .textFieldStyle(.roundedBorder)
                    .glassCard()
                }
                .padding(20)
            }
        }
        .preferredColorScheme(.dark)
    }
}
