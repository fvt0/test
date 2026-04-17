import Foundation
import MapKit
import CoreLocation

struct Restaurant: Identifiable, Hashable {
    let id: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let distanceMeters: CLLocationDistance?
    let phone: String?

    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum RestaurantSearchError: Error {
    case noLocation
    case noResults
}

struct RestaurantSearch {
    func search(keyword: String, around location: CLLocation?) async throws -> [Restaurant] {
        guard let location else { throw RestaurantSearchError.noLocation }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1500,
            longitudinalMeters: 1500
        )
        request.resultTypes = .pointOfInterest
        let response = try await MKLocalSearch(request: request).start()
        let items = response.mapItems
        guard !items.isEmpty else { throw RestaurantSearchError.noResults }
        return items.prefix(5).map { item in
            let coord = item.placemark.coordinate
            let distance = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                .distance(from: location)
            return Restaurant(
                id: "\(coord.latitude),\(coord.longitude),\(item.name ?? "")",
                name: item.name ?? "名称不明",
                address: [item.placemark.thoroughfare, item.placemark.subThoroughfare]
                    .compactMap { $0 }.joined(separator: " "),
                coordinate: coord,
                distanceMeters: distance,
                phone: item.phoneNumber
            )
        }.sorted { ($0.distanceMeters ?? .greatestFiniteMagnitude) < ($1.distanceMeters ?? .greatestFiniteMagnitude) }
    }
}
