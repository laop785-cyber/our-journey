import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject private var store: TripStore
    @State private var selectedTab = 0
    @State private var showingAddMemory = false
    @State private var showingAddRestaurant = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                memoriesScreen
            }
            .tabItem { Label("추억", systemImage: "book.closed.fill") }
            .tag(0)

            NavigationStack { TravelMapView() }
                .tabItem { Label("지도", systemImage: "map.fill") }
                .tag(1)

            NavigationStack { restaurantsScreen }
                .tabItem { Label("맛집", systemImage: "fork.knife") }
                .tag(2)

            NavigationStack { SettingsView() }
                .tabItem { Label("설정", systemImage: "gearshape.fill") }
                .tag(3)
        }
        .sheet(isPresented: $showingAddMemory) { AddMemoryView() }
        .sheet(isPresented: $showingAddRestaurant) { AddRestaurantView() }
    }

    private var memoriesScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("VIAMORI")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .tracking(1.5)
                    Text("다시 꺼내 보는 여행의 순간")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 12)

                Button { showingAddMemory = true } label: {
                    Label("여행지 추가", systemImage: "plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .foregroundStyle(.white)
                        .background(Color.viamoriCoral, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)

                HStack {
                    Text("여행 추억")
                        .font(.title2.bold())
                    Spacer()
                    Text("\(store.memories.count)개")
                        .foregroundStyle(.secondary)
                }

                if store.memories.isEmpty {
                    ContentUnavailableView("아직 기록이 없어요", systemImage: "airplane", description: Text("여행지 추가를 눌러 첫 추억을 남겨 보세요."))
                        .padding(.top, 20)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(store.memories) { memory in
                            NavigationLink {
                                MemoryDetailView(memory: memory)
                            } label: {
                                MemoryCard(memory: memory)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) { store.delete(memory) } label: {
                                    Label("기록 삭제", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 24)
        }
        .background(Color.viamoriCream.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var restaurantsScreen: some View {
        List {
            if store.restaurants.isEmpty {
                ContentUnavailableView("저장한 맛집이 없어요", systemImage: "fork.knife", description: Text("여행 중 기억하고 싶은 맛집을 저장해 보세요."))
                    .listRowBackground(Color.clear)
            } else {
                ForEach(store.restaurants) { restaurant in
                    VStack(alignment: .leading, spacing: 7) {
                        HStack {
                            Text(restaurant.name).font(.headline)
                            Spacer()
                            Text(String(repeating: "★", count: restaurant.rating))
                                .foregroundStyle(Color.viamoriCoral)
                        }
                        Text([restaurant.city, restaurant.country].filter { !$0.isEmpty }.joined(separator: ", "))
                            .font(.subheadline).foregroundStyle(.secondary)
                        if !restaurant.note.isEmpty { Text(restaurant.note).font(.subheadline) }
                        Text(restaurant.visitedAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 5)
                    .swipeActions {
                        Button(role: .destructive) { store.delete(restaurant) } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("맛집")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingAddRestaurant = true } label: { Image(systemName: "plus") }
                    .accessibilityLabel("맛집 추가")
            }
        }
    }
}

private struct MemoryCard: View {
    let memory: TripMemory

    var body: some View {
        HStack(spacing: 14) {
            Group {
                if let data = memory.photoData, let image = UIImage(data: data) {
                    Image(uiImage: image).resizable().scaledToFill()
                } else {
                    ZStack {
                        Color.viamoriCoral.opacity(0.13)
                        Image(systemName: "airplane").font(.title).foregroundStyle(Color.viamoriCoral)
                    }
                }
            }
            .frame(width: 82, height: 82)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 6) {
                Text(memory.title).font(.headline).foregroundStyle(.primary).lineLimit(1)
                Text([memory.city, memory.country].filter { !$0.isEmpty }.joined(separator: ", "))
                    .font(.subheadline).foregroundStyle(.secondary).lineLimit(1)
                Label(memory.date.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    .font(.caption).foregroundStyle(.secondary)
                if !memory.note.isEmpty {
                    Text(memory.note).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption.bold()).foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct MemoryDetailView: View {
    @EnvironmentObject private var store: TripStore
    @Environment(\.dismiss) private var dismiss
    let memory: TripMemory

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let data = memory.photoData, let image = UIImage(data: data) {
                    Image(uiImage: image).resizable().scaledToFill().frame(height: 280).clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    RoundedRectangle(cornerRadius: 20).fill(Color.viamoriCoral.opacity(0.12))
                        .frame(height: 190).overlay {
                            Image(systemName: "globe.europe.africa.fill").font(.system(size: 56)).foregroundStyle(Color.viamoriCoral)
                        }
                }
                Text(memory.title).font(.largeTitle.bold())
                Label([memory.city, memory.country].filter { !$0.isEmpty }.joined(separator: ", "), systemImage: "mappin.and.ellipse")
                    .font(.headline).foregroundStyle(Color.viamoriCoral)
                Label("\(memory.date.formatted(date: .long, time: .omitted)) · \(memory.time.formatted(date: .omitted, time: .shortened))", systemImage: "calendar")
                    .foregroundStyle(.secondary)
                if !memory.note.isEmpty {
                    Text(memory.note).font(.body).frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle("추억")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    store.delete(memory)
                    dismiss()
                } label: { Image(systemName: "trash") }
                .accessibilityLabel("기록 삭제")
            }
        }
    }
}

struct TravelMapView: View {
    @EnvironmentObject private var store: TripStore
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 20, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    )

    private var mappedMemories: [TripMemory] {
        store.memories.filter { $0.latitude != nil && $0.longitude != nil }
    }

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(mappedMemories) { memory in
                if let latitude = memory.latitude, let longitude = memory.longitude {
                    Marker(memory.city.isEmpty ? memory.title : memory.city, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .navigationTitle("여행 지도")
        .overlay(alignment: .bottom) {
            if mappedMemories.isEmpty {
                Label("여행지 추가 시 위도·경도를 입력하면 지도에 표시돼요", systemImage: "mappin.and.ellipse")
                    .font(.footnote).padding(12).background(.regularMaterial, in: Capsule()).padding()
            }
        }
    }
}

struct AddMemoryView: View {
    @EnvironmentObject private var store: TripStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var city = ""
    @State private var country = ""
    @State private var date = Date()
    @State private var time = Date()
    @State private var note = ""
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var photoData: Data?

    var body: some View {
        NavigationStack {
            Form {
                Section("여행지") {
                    TextField("기록 제목", text: $title)
                    TextField("도시 또는 장소", text: $city)
                    TextField("나라", text: $country)
                }
                Section("언제") {
                    DatePicker("날짜", selection: $date, displayedComponents: .date)
                    DatePicker("시간", selection: $time, displayedComponents: .hourAndMinute)
                }
                Section("추억") {
                    TextField("여행의 순간을 기록해 보세요", text: $note, axis: .vertical)
                        .lineLimit(3...7)
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Label(photoData == nil ? "사진 선택" : "사진 변경", systemImage: "photo")
                    }
                    if let photoData, let image = UIImage(data: photoData) {
                        Image(uiImage: image).resizable().scaledToFill().frame(height: 180).clipped().clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                Section {
                    TextField("위도 (예: 48.8584)", text: $latitude).keyboardType(.decimalPad)
                    TextField("경도 (예: 2.2945)", text: $longitude).keyboardType(.decimalPad)
                    Text("위도와 경도를 입력하면 지도에 핀이 표시됩니다.").font(.caption).foregroundStyle(.secondary)
                } header: { Text("지도 위치 · 선택") }
            }
            .navigationTitle("여행지 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("취소") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") { saveMemory() }.disabled(city.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .task(id: photoItem) {
                guard let photoItem else { return }
                photoData = try? await photoItem.loadTransferable(type: Data.self)
            }
        }
    }

    private func saveMemory() {
        let cleanCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        store.add(TripMemory(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? cleanCity : title,
            city: cleanCity,
            country: country.trimmingCharacters(in: .whitespacesAndNewlines),
            date: date,
            time: time,
            note: note,
            photoData: photoData,
            latitude: Double(latitude.replacingOccurrences(of: ",", with: ".")),
            longitude: Double(longitude.replacingOccurrences(of: ",", with: "."))
        ))
        dismiss()
    }
}

struct AddRestaurantView: View {
    @EnvironmentObject private var store: TripStore
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var city = ""
    @State private var country = ""
    @State private var visitedAt = Date()
    @State private var note = ""
    @State private var rating = 5

    var body: some View {
        NavigationStack {
            Form {
                Section("맛집 정보") {
                    TextField("식당 이름", text: $name)
                    TextField("도시", text: $city)
                    TextField("나라", text: $country)
                    DatePicker("방문 날짜", selection: $visitedAt, displayedComponents: .date)
                    Picker("별점", selection: $rating) {
                        ForEach(1...5, id: \.self) { value in Text(String(repeating: "★", count: value)).tag(value) }
                    }
                }
                Section("메모") {
                    TextField("추천 메뉴나 기억하고 싶은 점", text: $note, axis: .vertical).lineLimit(3...6)
                }
            }
            .navigationTitle("맛집 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("취소") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        store.add(RestaurantMemory(name: name.trimmingCharacters(in: .whitespacesAndNewlines), city: city, country: country, visitedAt: visitedAt, note: note, rating: rating))
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

struct SettingsView: View {
    @AppStorage("viamori.notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("viamori.showCountry") private var showCountry = true

    var body: some View {
        Form {
            Section("표시") {
                Toggle("여행 기록에 나라 표시", isOn: $showCountry)
                Toggle("여행 기록 알림", isOn: $notificationsEnabled)
            }
            Section("앱 정보") {
                LabeledContent("앱 이름", value: "VIAMORI")
                LabeledContent("버전", value: "1.0")
                Text("세상의 여행지와 소중한 순간을 기록하세요.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("설정")
    }
}

#Preview {
    ContentView().environmentObject(TripStore())
}
