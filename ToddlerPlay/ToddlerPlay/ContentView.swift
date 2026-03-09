import SwiftUI

struct ContentView: View {
    @State private var currentGame: GameType = .animals
    @State private var rainbowHue: Double = 0

    // Rainbow animation timer
    private let rainbowTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "FFF9E6"),
                    Color(hex: "FFF0F5"),
                    Color(hex: "F0F4FF"),
                    Color(hex: "E8FFF0"),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            FloatingStars()

            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    headerView

                    // Game Tabs
                    gameTabsView

                    // Game Content
                    gameContentView
                        .padding(.bottom, 40)
                }
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 4) {
            Text("✨ Baby Play Time! ✨")
                .font(.custom("Fredoka-Bold", size: 30))
                .foregroundColor(Color(hue: rainbowHue, saturation: 0.7, brightness: 0.7))
                .onReceive(rainbowTimer) { _ in
                    rainbowHue += 0.005
                    if rainbowHue > 1.0 { rainbowHue = 0 }
                }

            Text("Tap, learn & have fun!")
                .font(.custom("Fredoka-SemiBold", size: 14))
                .foregroundColor(.gray)
        }
        .padding(.top, 20)
        .padding(.bottom, 8)
    }

    // MARK: - Game Tabs
    private var gameTabsView: some View {
        HStack(spacing: 8) {
            ForEach(GameType.allCases) { game in
                GameTabButton(
                    game: game,
                    isSelected: currentGame == game
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        currentGame = game
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    // MARK: - Game Content
    private var gameContentView: some View {
        Group {
            switch currentGame {
            case .animals:
                AnimalGame()
            case .colors:
                ColorGame()
            case .bubbles:
                BubbleGame()
            case .shapes:
                ShapeGame()
            }
        }
        .transition(.asymmetric(
            insertion: .scale(scale: 0.9).combined(with: .opacity),
            removal: .scale(scale: 0.9).combined(with: .opacity)
        ))
        .id(currentGame)
    }
}

// MARK: - Game Tab Button
struct GameTabButton: View {
    let game: GameType
    let isSelected: Bool
    let action: () -> Void

    @State private var bounceOffset: CGFloat = 0

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Text(game.icon)
                    .font(.system(size: 18))
                Text(game.label)
                    .font(.custom("Fredoka-Bold", size: 15))
            }
            .foregroundColor(isSelected ? .white : Color(.systemGray))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [
                                Color(hex: "FF6B6B"),
                                Color(hex: "FFB347"),
                                Color(hex: "4ECDC4"),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color.white.opacity(0.7)
                    }
                }
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : Color(.systemGray4), lineWidth: isSelected ? 0 : 2)
            )
            .shadow(
                color: isSelected ? Color(hex: "FF6B6B").opacity(0.35) : .black.opacity(0.05),
                radius: isSelected ? 7 : 3,
                y: isSelected ? 2 : 2
            )
            .offset(y: bounceOffset)
        }
        .buttonStyle(.plain)
        .onChange(of: isSelected) { _, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.75).repeatForever(autoreverses: true)) {
                    bounceOffset = -4
                }
            } else {
                withAnimation(.default) {
                    bounceOffset = 0
                }
            }
        }
        .onAppear {
            if isSelected {
                withAnimation(.easeInOut(duration: 0.75).repeatForever(autoreverses: true)) {
                    bounceOffset = -4
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
