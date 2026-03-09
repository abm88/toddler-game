import SwiftUI

struct ShapeGame: View {
    @State private var activeIndex: Int? = nil
    @State private var showConfetti = false
    @State private var hits = 0

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        ZStack {
            ConfettiBurst(active: showConfetti)

            VStack(spacing: 16) {
                Text("🔷 Learn Shapes! 🔷")
                    .font(.custom("Fredoka-Bold", size: 22))
                    .foregroundColor(Color(hex: "D946EF"))
                    .shadow(color: Color(hex: "D946EF").opacity(0.15), radius: 0, x: 2, y: 2)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Array(ShapeItem.all.enumerated()), id: \.element.id) { index, shape in
                        ShapeCard(
                            shape: shape,
                            isActive: activeIndex == index
                        )
                        .onTapGesture {
                            handleTap(shape: shape, index: index)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 12)
        }
    }

    private func handleTap(shape: ShapeItem, index: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            activeIndex = index
        }
        SpeechHelper.shared.speak("This is a \(shape.name)!")
        hits += 1
        if hits % 3 == 0 {
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showConfetti = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation { activeIndex = nil }
        }
    }
}

struct ShapeCard: View {
    let shape: ShapeItem
    let isActive: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(shape.emoji)
                .font(.system(size: 56))
                .shadow(color: isActive ? .yellow : .clear, radius: isActive ? 12 : 0)

            Text(shape.name)
                .font(.custom("Fredoka-Bold", size: 18))
                .foregroundColor(shape.color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(shape.color.opacity(isActive ? 0.18 : 0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(shape.color, style: StrokeStyle(lineWidth: 3, dash: [8, 6]))
        )
        .scaleEffect(isActive ? 1.15 : 1.0)
        .rotationEffect(.degrees(isActive ? 10 : 0))
        .shadow(
            color: isActive ? shape.color.opacity(0.35) : .black.opacity(0.06),
            radius: isActive ? 15 : 6,
            y: isActive ? 4 : 4
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isActive)
    }
}
