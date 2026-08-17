import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progress: UserProgressStore
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 6) {
                    Text("PEG")
                        .font(.system(size: 52, weight: .black, design: .rounded))
                    Text("Number memory under pressure")
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                HStack(spacing: 12) {
                    statCard(title: "Points", value: "\(progress.points)")
                    statCard(title: "Timer", value: "\(progress.encodingSeconds)s")
                    statCard(title: "Level", value: "\(settings.selectedDigitLevel) digits")
                }

                NavigationLink {
                    TrainingView()
                } label: {
                    homeButton(title: "Train", subtitle: "Learn new numbers, then recall them", systemImage: "bolt.fill")
                }

                NavigationLink {
                    LongTermRecallView()
                } label: {
                    homeButton(title: "Long-Term Recall", subtitle: "Review numbers learned earlier", systemImage: "clock.arrow.circlepath")
                }

                NavigationLink {
                    StatsView()
                } label: {
                    homeButton(title: "Stats", subtitle: "Accuracy and accumulated progress", systemImage: "chart.bar.fill")
                }

                NavigationLink {
                    SettingsView()
                } label: {
                    homeButton(title: "Settings", subtitle: "Batch size and number length", systemImage: "gearshape.fill")
                }
            }
            .padding()
        }
        .navigationTitle("DynamoNumbers")
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func homeButton(title: String, subtitle: String, systemImage: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.title3.weight(.semibold))
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 18))
    }
}
