import Foundation
import Combine

final class AppSettings: ObservableObject {
    @Published var batchSize: Int = 5
    @Published var selectedDigitLevel: Int = 5

    let availableBatchSizes = Array(1...5)
    let availableDigitLevels = Array(5...10)
}
