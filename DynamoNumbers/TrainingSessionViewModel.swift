import Foundation
import Combine

@MainActor
final class TrainingSessionViewModel: ObservableObject {
    enum Phase {
        case learning
        case recall
        case finished
    }

    @Published private(set) var phase: Phase = .learning
    @Published private(set) var facts: [NumberFact] = []
    @Published private(set) var learningIndex: Int = 0
    @Published private(set) var recallIndex: Int = 0
    @Published private(set) var secondsRemaining: Int = 45
    @Published private(set) var results: [RecallResult] = []

    private var timer: AnyCancellable?
    private var allottedSeconds = 45

    var currentLearningFact: NumberFact? {
        guard facts.indices.contains(learningIndex) else { return nil }
        return facts[learningIndex]
    }

    var currentRecallFact: NumberFact? {
        guard facts.indices.contains(recallIndex) else { return nil }
        return facts[recallIndex]
    }

    func start(
        batchSize: Int,
        digitCount: Int,
        encodingSeconds: Int,
        masteredFacts: [NumberFact]
    ) {
        allottedSeconds = encodingSeconds

        let masteredIDs = Set(masteredFacts.map(\.id))

        let availablePool = SampleFacts
            .facts(forDigitCount: digitCount)
            .filter { !masteredIDs.contains($0.id) }
            .shuffled()

        facts = Array(availablePool.prefix(batchSize))

        learningIndex = 0
        recallIndex = 0
        results = []

        if facts.isEmpty {
            phase = .finished
        } else {
            phase = .learning
            resetTimer()
        }
    }

    func learnedCurrentFact() {
        guard phase == .learning else { return }

        timer?.cancel()

        if learningIndex + 1 < facts.count {
            learningIndex += 1
            resetTimer()
        } else {
            facts.shuffle()
            recallIndex = 0
            phase = .recall
        }
    }

    func submitRecall(_ enteredNumber: String) -> Bool {
        guard phase == .recall,
              let fact = currentRecallFact else {
            return false
        }

        let normalized = enteredNumber.filter(\.isNumber)
        let correct = normalized == fact.digitsOnly

        results.append(
            RecallResult(
                fact: fact,
                enteredNumber: normalized,
                wasCorrect: correct
            )
        )

        return correct
    }

    func advanceRecall() {
        guard phase == .recall else { return }

        if recallIndex + 1 < facts.count {
            recallIndex += 1
        } else {
            phase = .finished
        }
    }

    private func resetTimer() {
        secondsRemaining = allottedSeconds
        timer?.cancel()

        timer = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            guard let self,
                  self.phase == .learning else {
                return
            }

            if self.secondsRemaining > 1 {
                self.secondsRemaining -= 1
            } else {
                self.secondsRemaining = 0
                self.learnedCurrentFact()
            }
        }
    }

    deinit {
        timer?.cancel()
    }
}
