import Foundation

/// Bundled sample facts for the offline prototype.
/// Production data should be source-backed and refreshed deliberately.
enum SampleFacts {
    static let all: [NumberFact] = [
        NumberFact(
            prompt: "Approximate driving distance in miles from New York City to Los Angeles",
            number: 2790,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate height in feet of Mount Everest",
            number: 29032,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate circumference of Earth in miles",
            number: 24901,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate speed of sound at sea level in feet per second",
            number: 1125,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate distance from Earth to the Moon in miles",
            number: 238855,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate surface area of Lake Superior in square miles",
            number: 31700,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate length of the Equator in miles",
            number: 24901,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate elevation in feet of Denali",
            number: 20310,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate length in miles of the Mississippi River",
            number: 2340,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate maximum depth in feet of Lake Baikal",
            number: 5387,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate height in feet of Aconcagua",
            number: 22837,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate height in feet of Kilimanjaro",
            number: 19341,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate distance in miles from Earth to the Sun",
            number: 92955807,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate diameter of Earth in miles",
            number: 7918,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate area of California in square miles",
            number: 163696,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate area of Alaska in square miles",
            number: 665384,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate length in miles of the Nile River",
            number: 4132,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate height in feet of Mount Fuji",
            number: 12389,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate length in miles of the Great Wall of China",
            number: 13171,
            sourceNote: "Prototype sample fact"
        ),
        NumberFact(
            prompt: "Approximate land area of Texas in square miles",
            number: 261232,
            sourceNote: "Prototype sample fact"
        )
    ]

    static func facts(forDigitCount digitCount: Int) -> [NumberFact] {
        let exact = all.filter { $0.digitCount == digitCount }
        if !exact.isEmpty { return exact }

        // Prototype fallback so every level remains testable even if the bundled
        // sample set is sparse for a particular digit count.
        return generatedFacts(forDigitCount: digitCount)
    }

    private static func generatedFacts(forDigitCount digitCount: Int) -> [NumberFact] {
        let lower = Int(pow(10.0, Double(digitCount - 1)))
        let seeds = [12345, 27182, 31415, 40719, 52861, 63829, 74651, 85723, 96841, 10937]

        return seeds.enumerated().map { index, seed in
            let scaled = lower + ((seed * (index + 3) * 97) % (9 * lower))
            return NumberFact(
                prompt: "Prototype statistic \(index + 1) for \(digitCount)-digit training",
                number: scaled,
                sourceNote: "Generated placeholder for simulator testing"
            )
        }
    }
}
