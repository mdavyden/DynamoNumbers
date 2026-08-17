import SwiftUI

struct LongTermRecallView: View {
    @EnvironmentObject private var progress: UserProgressStore

    @State private var index = 0
    @State private var answer = ""
    @State private var resultText: String?

    private var facts: [NumberFact] {
        progress.masteredFacts
    }

    var body: some View {
        Group {
            if facts.isEmpty {
                ContentUnavailableView(
                    "Nothing to Review Yet",
                    systemImage: "brain.head.profile",
                    description: Text("Correctly recall facts in Train mode and they’ll become available here for optional long-term review.")
                )
            } else {
                VStack(spacing: 24) {
                    Spacer()

                    Text("LONG-TERM RECALL")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)

                    Text(facts[index % facts.count].prompt)
                        .font(.title.weight(.bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    TextField("Enter the number", text: $answer)
                        .keyboardType(.numberPad)
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)

                    if let resultText {
                        Text(resultText)
                            .foregroundStyle(.secondary)
                    }

                    Button(resultText == nil ? "Check" : "Next") {
                        if resultText == nil {
                            let fact = facts[index % facts.count]
                            let normalized = answer.filter(\.isNumber)
                            resultText = normalized == fact.digitsOnly
                                ? "Correct"
                                : "Correct answer: \(fact.formattedNumber)"
                        } else {
                            index = (index + 1) % facts.count
                            answer = ""
                            resultText = nil
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Long-Term Recall")
    }
}
