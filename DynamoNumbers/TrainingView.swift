import SwiftUI

struct TrainingView: View {
    @EnvironmentObject private var progress: UserProgressStore
    @EnvironmentObject private var settings: AppSettings
    @Environment(\.dismiss) private var dismiss

    @StateObject private var session = TrainingSessionViewModel()
    @State private var answer = ""
    @State private var showingCheatPenalty = false
    @State private var showingCheatSheet = false
    @State private var lastAnswerWasCorrect: Bool?

    var body: some View {
        Group {
            switch session.phase {
            case .learning:
                learningContent
            case .recall:
                recallContent
            case .finished:
                finishedContent
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cheat Sheet") {
                    showingCheatPenalty = true
                }
            }
        }
        .alert("View cheat sheet for −1 point?", isPresented: $showingCheatPenalty) {
            Button("Cancel", role: .cancel) {}
            Button("View") {
                progress.spendPointForCheatSheet()
                showingCheatSheet = true
            }
        } message: {
            Text("Your score cannot fall below zero.")
        }
        .sheet(isPresented: $showingCheatSheet) {
            MajorSystemCheatSheet()
        }
        .onAppear {
            if session.facts.isEmpty {
                session.start(
                    batchSize: settings.batchSize,
                    digitCount: settings.selectedDigitLevel,
                    encodingSeconds: progress.encodingSeconds,
                    masteredFacts: progress.masteredFacts
                )
            }
        }
    }

    private var learningContent: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("LEARN \(session.learningIndex + 1) OF \(session.facts.count)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            if let fact = session.currentLearningFact {
                Text(fact.formattedNumber)
                    .font(.system(size: 54, weight: .black, design: .rounded))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .monospacedDigit()

                Text(fact.prompt)
                    .font(.title2.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Text(timeString(session.secondsRemaining))
                .font(.system(size: 44, weight: .bold, design: .monospaced))
                .monospacedDigit()
                .padding(.vertical, 6)

            Text("Convert the number into your Major System mnemonic before time runs out.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                session.learnedCurrentFact()
            } label: {
                Text("I’ve Locked It In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Train")
    }

    private var recallContent: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("RECALL \(session.recallIndex + 1) OF \(session.facts.count)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            if let fact = session.currentRecallFact {
                Text(fact.prompt)
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            TextField("Enter the number", text: $answer)
                .keyboardType(.numberPad)
                .font(.system(size: 34, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .disabled(lastAnswerWasCorrect != nil)

            if let correct = lastAnswerWasCorrect,
               let fact = session.currentRecallFact {
                VStack(spacing: 8) {
                    Text(correct ? "+1 point" : "Not quite")
                        .font(.headline)
                    Text("Correct answer: \(fact.formattedNumber)")
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                handleRecallButton()
            } label: {
                Text(lastAnswerWasCorrect == nil ? "Submit" : "Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .disabled(lastAnswerWasCorrect == nil && answer.filter(\.isNumber).isEmpty)

            Spacer()
        }
        .padding()
        .navigationTitle("Recall")
    }

    private var finishedContent: some View {
        let correct = session.results.filter(\.wasCorrect).count

        return VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))

            Text("Session Complete")
                .font(.largeTitle.bold())

            Text("\(correct) of \(session.results.count) correct")
                .font(.title2)

            Text("Total points: \(progress.points)")
                .font(.headline)

            Button("Done") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Spacer()
        }
        .padding()
        .navigationTitle("Complete")
    }

    private func handleRecallButton() {
        if lastAnswerWasCorrect == nil {
            guard let fact = session.currentRecallFact else { return }
            let correct = session.submitRecall(answer)
            lastAnswerWasCorrect = correct

            if correct {
                progress.recordCorrect(fact)
            } else {
                progress.recordIncorrect()
            }
        } else {
            answer = ""
            lastAnswerWasCorrect = nil
            session.advanceRecall()
        }
    }

    private func timeString(_ seconds: Int) -> String {
        String(format: "00:%02d", seconds)
    }
}
