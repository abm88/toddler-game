import SwiftUI

struct FloatingStar: Identifiable {
    let id = UUID()
    let size: CGFloat
    let xPosition: CGFloat
    let delay: Double
    let duration: Double
}

struct FloatingStars: View {
    @State private var animate = false

    private let stars: [FloatingStar] = (0..<8).map { _ in
        FloatingStar(
            size: CGFloat.random(in: 16...40),
            xPosition: CGFloat.random(in: 0...1),
            delay: Double.random(in: 0...8),
            duration: Double.random(in: 6...12)
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(stars) { star in
                    Text("✨")
                        .font(.system(size: star.size))
                        .opacity(0.15)
                        .position(
                            x: geo.size.width * star.xPosition,
                            y: animate ? -40 : geo.size.height + 40
                        )
                        .animation(
                            .easeInOut(duration: star.duration)
                            .delay(star.delay)
                            .repeatForever(autoreverses: false),
                            value: animate
                        )
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear { animate = true }
    }
}
