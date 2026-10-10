import SwiftUI

struct MainView: View {
    @EnvironmentObject var store: Store

    private enum PickTarget: Identifiable {
        case single, launcher
        var id: Self { self }
    }
    @State private var picking: PickTarget?

    var body: some View {
        ZStack {
            Backdrop()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    modeSection
                    configSection
                    setupCard
                }
                .padding(20)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(item: $picking) { target in
            PresetPicker { item in
                switch target {
                case .single:
                    store.config.singleApp = item
                case .launcher:
                    if store.config.launcherItems.count < 8 {
                        store.config.launcherItems.append(item)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $store.launcherPresented) {
            LauncherView().environmentObject(store)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: "camera.aperture")
                .font(.system(size: 36))
                .foregroundStyle(accentGradient)
            Text("Aperture")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text("Make Camera Control launch anything.")
                .foregroundStyle(.secondary)
        }
        .padding(.top, 20)
    }

    private var modeSection: some View {
        VStack(spacing: 12) {
            ForEach(LaunchMode.allCases) { mode in
                let selected = store.config.mode == mode
                Button {
                    withAnimation(.spring(response: 0.3)) { store.config.mode = mode }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: mode.symbol)
                            .font(.title2)
                            .foregroundStyle(accentGradient)
                            .frame(width: 34)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(mode.title).font(.system(.headline, design: .rounded))
                            Text(mode.subtitle).font(.footnote).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(selected ? Color.cyan : Color.white.opacity(0.3))
                    }
                    .glassCard()
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .strokeBorder(selected ? Color.cyan.opacity(0.8) : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(PressStyle())
            }
        }
    }

    @ViewBuilder
    private var configSection: some View {
        switch store.config.mode {
        case .app:
            VStack(alignment: .leading, spacing: 12) {
                Text("Target app").font(.headline)
                if let app = store.config.singleApp {
                    row(app) { store.config.singleApp = nil }
                }
                Button { picking = .single } label: {
                    Label(store.config.singleApp == nil ? "Choose app" : "Change app",
                          systemImage: "plus.app.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent).tint(.purple)
            }
            .glassCard()

        case .shortcut:
            VStack(alignment: .leading, spacing: 12) {
                Text("Shortcut name").font(.headline)
                TextField("Exactly as it appears in Shortcuts", text: $store.config.shortcutName)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                Text("iOS doesn't let apps list your Shortcuts, so type the name exactly.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .glassCard()

        case .launcher:
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Launcher apps").font(.headline)
                    Spacer()
                    Text("\(store.config.launcherItems.count)/8").foregroundStyle(.secondary)
                }
                ForEach(store.config.launcherItems) { item in
                    row(item) {
                        store.config.launcherItems.removeAll { $0.id == item.id }
                    }
                }
                Button { picking = .launcher } label: {
                    Label("Add app", systemImage: "plus.app.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent).tint(.purple)
                .disabled(store.config.launcherItems.count >= 8)
            }
            .glassCard()
        }
    }

    private func row(_ item: LaunchItem, remove: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            Image(systemName: item.symbol).foregroundStyle(accentGradient).frame(width: 28)
            Text(item.name)
            Spacer()
            Button(role: .destructive, action: remove) {
                Image(systemName: "trash").foregroundStyle(Color.red.opacity(0.9))
            }
        }
    }

    private var setupCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hook up Camera Control").font(.headline)
            Text("Settings → Camera → Camera Control → choose Aperture.")
                .font(.footnote).foregroundStyle(.secondary)
            Button { store.trigger() } label: {
                Label("Test it now", systemImage: "play.fill").frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered).tint(.cyan)
        }
        .glassCard()
    }
}
