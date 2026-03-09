import SwiftUI

// MARK: - Game Types
enum GameType: String, CaseIterable, Identifiable {
    case animals, colors, bubbles, shapes

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .animals: return "🐾"
        case .colors: return "🎨"
        case .bubbles: return "🫧"
        case .shapes: return "🔷"
        }
    }

    var label: String {
        switch self {
        case .animals: return "Animals"
        case .colors: return "Colors"
        case .bubbles: return "Bubbles"
        case .shapes: return "Shapes"
        }
    }
}

// MARK: - Animal Data
struct Animal: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let sound: String
    let color: Color

    static let all: [Animal] = [
        Animal(emoji: "🐶", name: "Dog", sound: "Woof!", color: Color(hex: "FF8C42")),
        Animal(emoji: "🐱", name: "Cat", sound: "Meow!", color: Color(hex: "E85D75")),
        Animal(emoji: "🐮", name: "Cow", sound: "Moo!", color: Color(hex: "7CB342")),
        Animal(emoji: "🐷", name: "Pig", sound: "Oink!", color: Color(hex: "F48FB1")),
        Animal(emoji: "🐸", name: "Frog", sound: "Ribbit!", color: Color(hex: "66BB6A")),
        Animal(emoji: "🦁", name: "Lion", sound: "Roar!", color: Color(hex: "FFB300")),
        Animal(emoji: "🐔", name: "Chicken", sound: "Cluck!", color: Color(hex: "FF7043")),
        Animal(emoji: "🦆", name: "Duck", sound: "Quack!", color: Color(hex: "42A5F5")),
        Animal(emoji: "🐑", name: "Sheep", sound: "Baa!", color: Color(hex: "BDBDBD")),
    ]
}

// MARK: - Color Data
struct ColorItem: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let emoji: String

    static let all: [ColorItem] = [
        ColorItem(name: "Red", color: Color(hex: "EF4444"), emoji: "❤️"),
        ColorItem(name: "Blue", color: Color(hex: "3B82F6"), emoji: "💙"),
        ColorItem(name: "Green", color: Color(hex: "22C55E"), emoji: "💚"),
        ColorItem(name: "Yellow", color: Color(hex: "EAB308"), emoji: "💛"),
        ColorItem(name: "Purple", color: Color(hex: "A855F7"), emoji: "💜"),
        ColorItem(name: "Orange", color: Color(hex: "F97316"), emoji: "🧡"),
    ]
}

// MARK: - Shape Data
struct ShapeItem: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let emoji: String

    static let all: [ShapeItem] = [
        ShapeItem(name: "Circle", color: Color(hex: "EF4444"), emoji: "🔴"),
        ShapeItem(name: "Star", color: Color(hex: "EAB308"), emoji: "⭐"),
        ShapeItem(name: "Heart", color: Color(hex: "EC4899"), emoji: "💖"),
        ShapeItem(name: "Moon", color: Color(hex: "A855F7"), emoji: "🌙"),
        ShapeItem(name: "Sun", color: Color(hex: "F59E0B"), emoji: "☀️"),
        ShapeItem(name: "Flower", color: Color(hex: "F472B6"), emoji: "🌸"),
    ]
}

// MARK: - Bubble Data
struct Bubble: Identifiable {
    let id = UUID()
    let hue: Double
    let size: CGFloat
    let xPosition: CGFloat
    var yPosition: CGFloat
    let emoji: String

    static let emojis = ["🫧", "🎈", "⭐", "🌈", "🦋", "🎀", "🍬", "🧸"]

    static func random(in bounds: CGSize) -> Bubble {
        Bubble(
            hue: Double.random(in: 0...360),
            size: CGFloat.random(in: 56...96),
            xPosition: CGFloat.random(in: 20...(bounds.width - 80)),
            yPosition: bounds.height + 20,
            emoji: emojis.randomElement()!
        )
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
