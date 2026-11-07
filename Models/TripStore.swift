import Foundation

@MainActor
final class TripStore: ObservableObject {
    @Published private(set) var memories: [TripMemory] = []
    @Published private(set) var restaurants: [RestaurantMemory] = []

    private let memoriesKey = "viamori.memories.v1"
    private let restaurantsKey = "viamori.restaurants.v1"

    init() {
        memories = load([TripMemory].self, forKey: memoriesKey)
        restaurants = load([RestaurantMemory].self, forKey: restaurantsKey)
    }

    func add(_ memory: TripMemory) {
        memories.insert(memory, at: 0)
        save(memories, forKey: memoriesKey)
    }

    func delete(_ memory: TripMemory) {
        memories.removeAll { $0.id == memory.id }
        save(memories, forKey: memoriesKey)
    }

    func add(_ restaurant: RestaurantMemory) {
        restaurants.insert(restaurant, at: 0)
        save(restaurants, forKey: restaurantsKey)
    }

    func delete(_ restaurant: RestaurantMemory) {
        restaurants.removeAll { $0.id == restaurant.id }
        save(restaurants, forKey: restaurantsKey)
    }

    private func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T {
        guard let data = UserDefaults.standard.data(forKey: key),
              let value = try? JSONDecoder().decode(type, from: data) else {
            return (T.self == [TripMemory].self ? [] : []) as! T
        }
        return value
    }

    private func save<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
