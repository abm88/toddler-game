import SwiftUI

struct BubbleGame: View {
    @State private var bubbles: [Bubble] = []
    @State private var score = 0
    @State private var showConfetti = false
    @State private var gameSize: CGSize = .zero

    private let spawnTimer = Timer.publish(every: 1.2, on: .main, in: .common).autoconnect()
    private let moveTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "E0F7FA"),
                    Color(hex: "B2EBF2"),
                    Color(hex: "80DEEA"),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))

            ConfettiBurst(active: showConfetti)

            VStack(spacing: 4) {
                Text("🫧 Pop the Bubbles! 🫧")
                    .font(.custom("Fredoka-Bold", size: 22))
                    .foregroundColor(Color(hex: "00897B"))
                    .shadow(color: Color(hex: "00897B").opacity(0.12), radius: 0, x: 2, y: 2)
                    .zIndex(10)

                HStack(spacing: 4) {
                    Text("Score: \(score)")
                        .font(.custom("Fredoka-Bold", size: 16))
                        .foregroundColor(Color(hex: "00695C"))

                    if score >= 10 {
                        Text("🏆")
                    } else if score >= 5 {
                        Text("⭐")
                    }
                }
                .zIndex(10)

                Spacer()
            }
            .padding(.top, 14)

            // Bubbles
            GeometryReader { geo in
                ForEach(bubbles) { bubble in
                    BubbleView(bubble: bubble)
                        .onTapGesture {
                            popBubble(id: bubble.id)
                        }
                }
                .onAppear {
                    gameSize = geo.size
                }
            }
        }
        .frame(minHeight: 460)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 8)
        .onReceive(spawnTimer) { _ in
            guard gameSize != .zero else { return }
            let newBubble = Bubble.random(in: gameSize)
            bubbles.append(newBubble)
            if bubbles.count > 12 {
                bubbles.removeFirst()
            }
        }
        .onReceive(moveTimer) { _ in
            for i in bubbles.indices {
                bubbles[i].yPosition -= 1.8
            }
            bubbles.removeAll { $0.yPosition < -$0.size }
        }
    }

    private func popBubble(id: UUID) {
        withAnimation(.easeOut(duration: 0.2)) {
            bubbles.removeAll { $0.id == id }
        }
        score += 1
        SpeechHelper.shared.speak("Pop!", rate: 0.55)
        if score % 5 == 0 {
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showConfetti = false
            }
        }
    }
}

struct BubbleView: View {
    let bubble: Bubble

    var body: some View {
        Text(bubble.emoji)
            .font(.system(size: bubble.size * 0.45))
            .frame(width: bubble.size, height: bubble.size)
            .background(
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .white.opacity(0.7),
                                Color(hue: bubble.hue / 360, saturation: 0.7, brightness: 0.7),
                                Color(hue: bubble.hue / 360, saturation: 0.6, brightness: 0.5),
                            ],
                            center: UnitPoint(x: 0.35, y: 0.35),
                            startRadius: 0,
                            endRadius: bubble.size / 2
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                Color(hue: bubble.hue / 360, saturation: 0.5, brightness: 0.8),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(
                color: Color(hue: bubble.hue / 360, saturation: 0.5, brightness: 0.7).opacity(0.4),
                radius: 10,
                y: 4
            )
            .position(x: bubble.xPosition, y: bubble.yPosition)
    }
}
