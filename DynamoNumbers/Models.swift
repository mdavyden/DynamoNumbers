import Foundation

struct NumberFact: Identifiable, Hashable {
    let id = UUID()
    let prompt: String
    let number: Int
    let sourceNote: String

    var digitsOnly: String {
        String(number)
    }

    var digitCount: Int {
        digitsOnly.count
    }

    var formattedNumber: String {
        number.formatted(.number.grouping(.automatic))
    }
}

struct RecallResult: Identifiable {
    let id = UUID()
    let fact: NumberFact
    let enteredNumber: String
    let wasCorrect: Bool
}

struct TrainingSessionSummary {
    let totalFacts: Int
    let correctAnswers: Int

    var accuracy: Double {
        guard totalFacts > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalFacts)
    }
}
