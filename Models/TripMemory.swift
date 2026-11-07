import Foundation

struct TripMemory: Identifiable, Hashable {
    let id: UUID
    var title: String
    var city: String
    var country: String
    var date: Date
    var time: Date
    var note: String
    var photoName: String
    var latitude: Double
    var longitude: Double
    var favoriteRestaurant: String

    init(
        id: UUID = UUID(),
        title: String,
        city: String,
        country: String,
        date: Date,
        time: Date,
        note: String,
        photoName: String = "photo.fill",
        latitude: Double,
        longitude: Double,
        favoriteRestaurant: String = ""
    ) {
        self.id = id
        self.title = title
        self.city = city
        self.country = country
        self.date = date
        self.time = time
        self.note = note
        self.photoName = photoName
        self.latitude = latitude
        self.longitude = longitude
        self.favoriteRestaurant = favoriteRestaurant
    }
}
