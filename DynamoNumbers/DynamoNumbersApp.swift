import SwiftUI

@main
struct DynamoNumbersApp: App {
    @StateObject private var progress = UserProgressStore()
    @StateObject private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(progress)
                .environmentObject(settings)
        }
    }
}
