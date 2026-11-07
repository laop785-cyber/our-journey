# VIAMORI

**VIAMORI** is a SwiftUI iOS travel journal for collecting destinations, dates, photos, memories, and favorite restaurants.

## MVP features
- Add a travel memory with place, country, date, time, note, and optional photo
- Store memories locally on the device
- Browse a memory timeline and detail screen
- Add favorite restaurants with a visit date, note, and rating
- Show saved locations on a map when latitude and longitude are provided
- Basic settings

## Add to an Xcode project
1. In Xcode, create a new **iOS App** project named `VIAMORI`.
2. Select **SwiftUI** for Interface and **Swift** for Language. Set the deployment target to **iOS 17.0 or later**.
3. Add the files in `App`, `Models`, and `Views` to the project, making sure **Copy items if needed** and the `VIAMORI` target are selected.
4. Build and run on an iPhone simulator or device.

## Notes
- The first version uses `UserDefaults` for local persistence; data does not sync across devices and is removed if the app is deleted.
- The map uses manually entered latitude and longitude. Place search, automatic geocoding, iCloud sync, and push notifications are not included yet.
