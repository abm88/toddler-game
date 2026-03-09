import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let x: CGFloat
    let size: CGFloat
    let hue: Double
    let delay: Double
    let duration: Double
    let isCircle: Bool
}

struct ConfettiBurst: View {
    let active: Bool

    @State private var pieces: [ConfettiPiece] = []
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(pieces) { piece in
                Circle()
                    .fill(Color(hue: piece.hue / 360, saturation: 0.8, brightness: 0.7))
                    .frame(width: piece.size, height: piece.size)
                    .clipShape(piece.isCircle ? AnyShape(Circle()) : AnyShape(Rectangle()))
                    .position(x: piece.x, y: animate ? UIScreen.main.bounds.height + 40 : -20)
                    .rotationEffect(.degrees(animate ? 720 : 0))
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeIn(duration: piece.duration)
                        .delay(piece.delay),
                        value: animate
                    )
            }
        }
        .allowsHitTesting(false)
        .onChange(of: active) { _, newValue in
            if newValue {
                generatePieces()
                animate = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animate = true
                }
            }
        }
    }

    private func generatePieces() {
        let screenWidth = UIScreen.main.bounds.width
        pieces = (0..<20).map { _ in
            ConfettiPiece(
                x: CGFloat.random(in: 0...screenWidth),
                size: CGFloat.random(in: 8...20),
                hue: Double.random(in: 0...360),
                delay: Double.random(in: 0...0.3),
                duration: Double.random(in: 1...2),
                isCircle: Bool.random()
            )
        }
    }
}
