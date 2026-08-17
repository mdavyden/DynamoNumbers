import Foundation
import Combine

final class UserProgressStore: ObservableObject {
    @Published private(set) var points: Int = 0
    @Published private(set) var totalAnswered: Int = 0
    @Published private(set) var totalCorrect: Int = 0
    @Published private(set) var masteredFacts: [NumberFact] = []

    func recordCorrect(_ fact: NumberFact) {
        points += 1
        totalAnswered += 1
        totalCorrect += 1

        if !masteredFacts.contains(fact) {
            masteredFacts.append(fact)
        }
    }

    func recordIncorrect() {
        totalAnswered += 1
    }

    func spendPointForCheatSheet() {
        points = max(0, points - 1)
    }

    var lifetimeAccuracy: Double {
        guard totalAnswered > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalAnswered)
    }

    var encodingSeconds: Int {
        switch points {
        case 0..<10: return 45
        case 10..<25: return 40
        case 25..<50: return 35
        case 50..<100: return 30
        case 100..<175: return 25
        case 175..<275: return 20
        case 275..<400: return 15
        case 400..<600: return 12
        case 600..<800: return 10
        case 800..<1000: return 8
        default: return 5
        }
    }
}
