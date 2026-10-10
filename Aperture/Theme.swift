import SwiftUI

extension View {
    func glassCard(_ radius: CGFloat = 22) -> some View {
        self
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.12))
            )
    }
}

struct Backdrop: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.05, blue: 0.12), Color(red: 0.12, green: 0.07, blue: 0.25)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Circle().fill(Color.purple.opacity(0.35)).frame(width: 280, height: 280)
                .blur(radius: 90).offset(x: 140, y: -260)
            Circle().fill(Color.cyan.opacity(0.25)).frame(width: 260, height: 260)
                .blur(radius: 90).offset(x: -150, y: 300)
        }
        .ignoresSafeArea()
    }
}

struct PressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

let accentGradient = LinearGradient(colors: [.cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
