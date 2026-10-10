import SwiftUI
import LockedCameraCapture

/// Runs when Camera Control is pressed. It does nothing except hand off to the main app,
/// which reads its own saved settings and decides what to open.
@main
struct ApertureCapture: LockedCameraCaptureExtension {
    var body: some LockedCameraCaptureExtensionScene {
        LockedCameraCaptureUIScene { session in
            HandoffView(session: session)
        }
    }
}

struct HandoffView: View {
    let session: LockedCameraCaptureSession

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ProgressView().tint(.white)
        }
        .task {
            let activity = NSUserActivity(activityType: NSUserActivityTypeLockedCameraCapture)
            try? await session.openApplication(for: activity)
        }
    }
}
