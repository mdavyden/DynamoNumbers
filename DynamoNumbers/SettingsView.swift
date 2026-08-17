import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var progress: UserProgressStore

    var body: some View {
        Form {
            Section("Training") {
                Picker("Facts per session", selection: $settings.batchSize) {
                    ForEach(settings.availableBatchSizes, id: \.self) { size in
                        Text("\(size)").tag(size)
                    }
                }

                Picker("Number length", selection: $settings.selectedDigitLevel) {
                    ForEach(settings.availableDigitLevels, id: \.self) { digits in
                        Text("\(digits) digits").tag(digits)
                    }
                }
            }

            Section("Current Difficulty") {
                LabeledContent("Points", value: "\(progress.points)")
                LabeledContent("Encoding timer", value: "\(progress.encodingSeconds) seconds")
            }

            Section("Progression") {
                Text("This prototype lets you manually select any 5–10 digit level so every level is testable. Automatic mastery-based unlocking can be added once the training loop is validated.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}
