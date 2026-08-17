import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var progress: UserProgressStore

    var body: some View {
        List {
            Section("Lifetime") {
                LabeledContent("Points", value: "\(progress.points)")
                LabeledContent("Questions answered", value: "\(progress.totalAnswered)")
                LabeledContent("Correct", value: "\(progress.totalCorrect)")
                LabeledContent("Accuracy", value: progress.lifetimeAccuracy.formatted(.percent.precision(.fractionLength(0))))
            }

            Section("Speed") {
                LabeledContent("Current learning timer", value: "\(progress.encodingSeconds) sec")
            }

            Section("Long-Term Library") {
                LabeledContent("Stored learned facts", value: "\(progress.masteredFacts.count)")
            }
        }
        .navigationTitle("Stats")
    }
}
