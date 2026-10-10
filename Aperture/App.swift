import SwiftUI
import LockedCameraCapture
import AVFoundation

@main
struct ApertureApp: App {
    @StateObject private var store = Store()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(store)
                .task { _ = await AVCaptureDevice.requestAccess(for: .video) }
                .onContinueUserActivity(NSUserActivityTypeLockedCameraCapture) { _ in
                    // Camera Control was pressed -> run whatever the user configured.
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        store.trigger()
                    }
                }
        }
    }
}
