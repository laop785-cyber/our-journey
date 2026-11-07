import SwiftUI

@main
struct VIAMORIApp: App {
    @StateObject private var store = TripStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .tint(Color.viamoriCoral)
        }
    }
}

extension Color {
    static let viamoriCoral = Color(red: 0.91, green: 0.38, blue: 0.29)
    static let viamoriCream = Color(red: 0.98, green: 0.96, blue: 0.92)
}
