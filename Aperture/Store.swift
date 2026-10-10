import SwiftUI
import UIKit

@MainActor
final class Store: ObservableObject {
    private static let key = "config.v1"

    @Published var config: Config { didSet { save() } }
    @Published var launcherPresented = false

    init() {
        if let data = UserDefaults.standard.data(forKey: Store.key),
           let saved = try? JSONDecoder().decode(Config.self, from: data) {
            config = saved
        } else {
            config = Config()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(config) {
            UserDefaults.standard.set(data, forKey: Store.key)
        }
    }

    /// Called when Camera Control is pressed (or "Test" is tapped).
    func trigger() {
        switch config.mode {
        case .app:
            if let app = config.singleApp { Launcher.open(app.urlString) }
        case .shortcut:
            Launcher.runShortcut(config.shortcutName)
        case .launcher:
            launcherPresented = true
        }
    }
}

enum Launcher {
    @MainActor static func open(_ string: String) {
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url)
    }

    @MainActor static func runShortcut(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var c = URLComponents()
        c.scheme = "shortcuts"
        c.host = "run-workflow"
        c.queryItems = [URLQueryItem(name: "name", value: trimmed)]
        if let url = c.url { UIApplication.shared.open(url) }
    }
}
