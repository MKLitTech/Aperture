import Foundation

enum LaunchMode: String, Codable, CaseIterable, Identifiable {
    case app, shortcut, launcher
    var id: String { rawValue }

    var title: String {
        switch self {
        case .app: return "Open an App"
        case .shortcut: return "Run a Shortcut"
        case .launcher: return "Quick Launcher"
        }
    }
    var subtitle: String {
        switch self {
        case .app: return "Jump straight into one app"
        case .shortcut: return "Run a Shortcut by name"
        case .launcher: return "Open a grid of 4–8 apps"
        }
    }
    var symbol: String {
        switch self {
        case .app: return "arrow.up.forward.app.fill"
        case .shortcut: return "square.stack.3d.up.fill"
        case .launcher: return "square.grid.2x2.fill"
        }
    }
}

struct LaunchItem: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var symbol: String
    var urlString: String
}

struct Config: Codable {
    var mode: LaunchMode = .launcher
    var singleApp: LaunchItem? = nil
    var shortcutName: String = ""
    var launcherItems: [LaunchItem] = []
}

/// iOS has no API to list installed apps, so we ship common URL schemes.
/// Anything missing can be added as a custom URL scheme in the picker.
enum Presets {
    static let all: [LaunchItem] = [
        LaunchItem(name: "Instagram", symbol: "camera.fill", urlString: "instagram://"),
        LaunchItem(name: "WhatsApp", symbol: "message.fill", urlString: "whatsapp://"),
        LaunchItem(name: "Telegram", symbol: "paperplane.fill", urlString: "tg://"),
        LaunchItem(name: "Discord", symbol: "bubble.left.and.bubble.right.fill", urlString: "discord://"),
        LaunchItem(name: "Spotify", symbol: "music.note", urlString: "spotify://"),
        LaunchItem(name: "YouTube", symbol: "play.rectangle.fill", urlString: "youtube://"),
        LaunchItem(name: "Maps", symbol: "map.fill", urlString: "maps://"),
        LaunchItem(name: "Google Maps", symbol: "location.fill", urlString: "comgooglemaps://"),
        LaunchItem(name: "Music", symbol: "music.quarternote.3", urlString: "music://"),
        LaunchItem(name: "Mail", symbol: "envelope.fill", urlString: "message://"),
        LaunchItem(name: "Messages", symbol: "text.bubble.fill", urlString: "sms://"),
        LaunchItem(name: "Phone", symbol: "phone.fill", urlString: "tel://"),
        LaunchItem(name: "Notes", symbol: "note.text", urlString: "mobilenotes://"),
        LaunchItem(name: "Photos", symbol: "photo.fill", urlString: "photos-redirect://"),
        LaunchItem(name: "Calendar", symbol: "calendar", urlString: "calshow://"),
        LaunchItem(name: "Reminders", symbol: "checklist", urlString: "x-apple-reminderkit://"),
        LaunchItem(name: "Files", symbol: "folder.fill", urlString: "shareddocuments://"),
        LaunchItem(name: "Wallet", symbol: "creditcard.fill", urlString: "shoebox://"),
        LaunchItem(name: "X", symbol: "bird.fill", urlString: "twitter://"),
        LaunchItem(name: "Reddit", symbol: "text.bubble", urlString: "reddit://"),
        LaunchItem(name: "Snapchat", symbol: "ghost.fill", urlString: "snapchat://"),
        LaunchItem(name: "Netflix", symbol: "tv.fill", urlString: "nflx://"),
        LaunchItem(name: "Chrome", symbol: "globe", urlString: "googlechrome://"),
        LaunchItem(name: "Gmail", symbol: "envelope.badge.fill", urlString: "googlegmail://"),
        LaunchItem(name: "Slack", symbol: "number", urlString: "slack://"),
        LaunchItem(name: "Uber", symbol: "car.fill", urlString: "uber://"),
        LaunchItem(name: "Shortcuts", symbol: "square.stack.3d.up.fill", urlString: "shortcuts://"),
        LaunchItem(name: "Browser", symbol: "safari.fill", urlString: "https://"),
    ]
}
