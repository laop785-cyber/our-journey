# VIAMORI

**VIAMORI** is a SwiftUI iOS travel journal for collecting destinations, dates, photos, memories, and favorite restaurants.

## MVP features
- Add a travel memory with place, country, date, time, note, and optional photo
- Store memories locally on the device
- Browse a memory timeline and detail screen
- Add favorite restaurants with a visit date, note, and rating
- Show saved locations on a map using manually entered coordinates or place-name geocoding
- Basic settings and a country-visibility preference

## Build with Xcode

This repository includes an XcodeGen specification so the project file can be generated consistently.

1. Install Xcode on macOS and install [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`).
2. Clone this repository and open Terminal in its root directory.
3. Run `xcodegen generate` to create `VIAMORI.xcodeproj` from `project.yml`.
4. Open `VIAMORI.xcodeproj`, select an iOS 17+ simulator, and build/run.

Alternatively, create a new iOS App project using SwiftUI and Swift, then add all Swift files under `App`, `Models`, and `Views` to the app target.

## Current limitations
- Data and selected photos are stored locally with `UserDefaults`; there is no account or cross-device sync. Large photo collections should move to file storage or SwiftData.
- Place-name geocoding uses Apple's geocoding service and may need network connectivity; users can enter coordinates manually if lookup fails.
- Notifications are not implemented yet; their setting is disabled so it does not imply a feature that is not present.
- This repository was not compiled in Xcode in this environment. Build and test on macOS before distribution.
