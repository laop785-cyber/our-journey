import Foundation

struct TripMemory: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var city: String
    var country: String
    var date: Date
    var time: Date
    var note: String
    var photoData: Data?
    var latitude: Double?
    var longitude: Double?
}

struct RestaurantMemory: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var city: String
    var country: String
    var visitedAt: Date
    var note: String
    var rating: Int
}
