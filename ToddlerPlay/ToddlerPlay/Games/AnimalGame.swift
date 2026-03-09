import SwiftUI

struct AnimalGame: View {
    @State private var tappedIndex: Int? = nil
    @State private var showConfetti = false
    @State private var score = 0

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
    ]

    var body: some View {
        ZStack {
            ConfettiBurst(active: showConfetti)

            VStack(spacing: 16) {
                Text("🐾 Tap the Animals! 🐾")
                    .font(.custom("Fredoka-Bold", size: 22))
                    .foregroundColor(Color(hex: "FF6B35"))
                    .shadow(color: Color(hex: "FF6B35").opacity(0.15), radius: 0, x: 2, y: 2)

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(Array(Animal.all.enumerated()), id: \.element.id) { index, animal in
                        AnimalCard(
                            animal: animal,
                            isTapped: tappedIndex == index
                        )
                        .onTapGesture {
                            handleTap(animal: animal, index: index)
                        }
                    }
                }
                .padding(.horizontal, 8)

                if score >= 3 {
                    Text("🌟 Great job! You found \(score) animals! 🌟")
                        .font(.custom("Fredoka-Bold", size: 20))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
        }
    }

    private func handleTap(animal: Animal, index: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            tappedIndex = index
        }
        SpeechHelper.shared.speak("\(animal.sound) I'm a \(animal.name)!")
        score += 1
        if score > 0 && score % 3 == 0 {
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showConfetti = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation { tappedIndex = nil }
        }
    }
}

struct AnimalCard: View {
    let animal: Animal
    let isTapped: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 4) {
                Text(animal.emoji)
                    .font(.system(size: 52))
                    .shadow(color: isTapped ? .yellow : .clear, radius: isTapped ? 8 : 0)

                Text(animal.name)
                    .font(.custom("Fredoka-Bold", size: 13))
                    .foregroundColor(animal.color)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(animal.color.opacity(isTapped ? 0.25 : 0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(animal.color, lineWidth: 3)
            )
            .scaleEffect(isTapped ? 1.25 : 1.0)
            .rotationEffect(.degrees(isTapped ? -5 : 0))
            .shadow(
                color: isTapped ? animal.color.opacity(0.5) : .black.opacity(0.08),
                radius: isTapped ? 15 : 6,
                y: isTapped ? 4 : 4
            )

            if isTapped {
                Text(animal.sound)
                    .font(.custom("Fredoka-Bold", size: 14))
                    .foregroundColor(animal.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(.white)
                            .overlay(Capsule().stroke(animal.color, lineWidth: 2))
                    )
                    .shadow(radius: 4)
                    .offset(x: 10, y: -18)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isTapped)
    }
}
