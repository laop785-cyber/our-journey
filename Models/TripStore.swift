import Combine
import Foundation

@MainActor
final class TripStore: ObservableObject {
    @Published private(set) var memories: [TripMemory]
    @Published private(set) var restaurants: [RestaurantMemory]

    private let memoriesKey = "viamori.memories.v1"
    private let restaurantsKey = "viamori.restaurants.v1"

    init() {
        memories = Self.load([TripMemory].self, forKey: "viamori.memories.v1", default: [])
        restaurants = Self.load([RestaurantMemory].self, forKey: "viamori.restaurants.v1", default: [])
    }

    func add(_ memory: TripMemory) {
        memories.insert(memory, at: 0)
        persist(memories, forKey: memoriesKey)
    }

    func delete(_ memory: TripMemory) {
        memories.removeAll { $0.id == memory.id }
        persist(memories, forKey: memoriesKey)
    }

    func add(_ restaurant: RestaurantMemory) {
        restaurants.insert(restaurant, at: 0)
        persist(restaurants, forKey: restaurantsKey)
    }

    func delete(_ restaurant: RestaurantMemory) {
        restaurants.removeAll { $0.id == restaurant.id }
        persist(restaurants, forKey: restaurantsKey)
    }

    private static func load<Value: Decodable>(
        _ type: Value.Type,
        forKey key: String,
        default defaultValue: Value
    ) -> Value {
        guard let data = UserDefaults.standard.data(forKey: key),
              let value = try? JSONDecoder().decode(type, from: data) else {
            return defaultValue
        }
        return value
    }

    private func persist<Value: Encodable>(_ value: Value, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
