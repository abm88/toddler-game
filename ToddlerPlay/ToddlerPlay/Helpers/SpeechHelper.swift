import AVFoundation

final class SpeechHelper {
    static let shared = SpeechHelper()
    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    func speak(_ text: String, rate: Float = 0.45) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = 1.3
        utterance.volume = 1.0
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
