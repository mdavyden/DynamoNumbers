import SwiftUI

struct MajorSystemCheatSheet: View {
    let rows: [(String, String)] = [
        ("0", "s, x, z"),
        ("1", "t, d"),
        ("2", "n"),
        ("3", "m"),
        ("4", "r"),
        ("5", "l"),
        ("6", "sh, ch, j, soft g"),
        ("7", "c, k, hard g, q"),
        ("8", "f, v"),
        ("9", "p, b")
    ]

    var body: some View {
        NavigationStack {
            List(rows, id: \.0) { digit, sounds in
                HStack(alignment: .firstTextBaseline) {
                    Text(digit)
                        .font(.title2.monospacedDigit().bold())
                        .frame(width: 40, alignment: .leading)
                    Text(sounds)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Major System")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
