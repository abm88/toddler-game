import SwiftUI

struct ColorGame: View {
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
                Text("🎨 Learn Colors! 🎨")
                    .font(.custom("Fredoka-Bold", size: 22))
                    .foregroundColor(Color(hex: "8B5CF6"))
                    .shadow(color: Color(hex: "8B5CF6").opacity(0.15), radius: 0, x: 2, y: 2)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Array(ColorItem.all.enumerated()), id: \.element.id) { index, colorItem in
                        ColorCard(
                            colorItem: colorItem,
                            isActive: activeIndex == index
                        )
                        .onTapGesture {
                            handleTap(colorItem: colorItem, index: index)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 12)
        }
    }

    private func handleTap(colorItem: ColorItem, index: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            activeIndex = index
        }
        SpeechHelper.shared.speak("This is \(colorItem.name)!")
        hits += 1
        if hits % 4 == 0 {
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showConfetti = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation { activeIndex = nil }
        }
    }
}

struct ColorCard: View {
    let colorItem: ColorItem
    let isActive: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(colorItem.emoji)
                .font(.system(size: 44))
                .brightness(isActive ? 0.3 : 0)

            Text(colorItem.name)
                .font(.custom("Fredoka-Bold", size: 20))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    isActive
                        ? RadialGradient(
                            colors: [.white, colorItem.color],
                            center: .center,
                            startRadius: 10,
                            endRadius: 80
                        )
                        : RadialGradient(
                            colors: [colorItem.color, colorItem.color.opacity(0.8)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                )
        )
        .scaleEffect(isActive ? 1.15 : 1.0)
        .shadow(
            color: isActive ? colorItem.color.opacity(0.5) : colorItem.color.opacity(0.25),
            radius: isActive ? 20 : 8,
            y: isActive ? 4 : 6
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isActive)
    }
}
