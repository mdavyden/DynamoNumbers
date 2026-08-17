# DynamoNumbers Prototype

A SwiftUI prototype for iOS that trains one-way number recall using the Major System mapping supplied by the user.

## Setup in Xcode

1. Create a new **iOS App** project in Xcode using **SwiftUI** and **Swift**. Use **Product Name** `DynamoNumbers` and **Organization Identifier** `com.mdavy` (normally giving you bundle identifier `com.mdavy.DynamoNumbers`).
2. Delete the default `ContentView.swift`.
3. Add all `.swift` files from this folder to your app target.
4. Delete the generated `DynamoNumbersApp.swift`, then drag the `DynamoNumbersApp.swift` from this package into your project along with the other Swift files.
5. Build and run in an iPhone simulator.

No external packages are required.

## Prototype behavior

- Home screen with Train, Long-Term Recall, Stats, and Settings.
- Learn phase shows a complete real-world fact and its number together.
- A large visible countdown creates time pressure.
- The user never types a mnemonic or fills blanks during learning.
- After the batch is learned, recall prompts show only the statistic description.
- The only thing entered from memory is the number.
- Correct recall earns +1 point.
- Opening the Major System cheat sheet costs 1 point, with a confirmation alert.
- Batch size is adjustable from 1 to 5 facts.
- Number lengths progress from 5 through 10 digits.
- Timer decreases as points increase.
- Long-Term Recall is a separate mode and intentionally simple in this first prototype.

## Note on fact data

The prototype uses bundled sample facts so it runs immediately and offline. A production version should move facts into a curated/source-backed data layer with `asOfDate`, source attribution, and update logic.
