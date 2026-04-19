import SwiftUI
import MapKit

struct RestaurantListView: View {
    let meal: Meal
    let restaurants: [Restaurant]
    let isLoading: Bool
    let errorMessage: String?
    let onBack: () -> Void
    let onOpenRestaurant: (Restaurant, Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MessageBanner(text: Messages.confirmedComment)

            HStack {
                Text(meal.emoji).font(.largeTitle)
                Text(meal.name).font(.title2).bold()
                Spacer()
            }

            if isLoading {
                ProgressView("お店を探しています…")
                    .frame(maxWidth: .infinity, minHeight: 120)
            } else if let errorMessage {
                Text(errorMessage).foregroundStyle(.secondary)
            } else if restaurants.isEmpty {
                Text("近くにお店が見つかりませんでした。").foregroundStyle(.secondary)
            } else {
                List(Array(restaurants.enumerated()), id: \.element.id) { pair in
                    Button {
                        onOpenRestaurant(pair.element, pair.offset)
                        openInMaps(pair.element)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pair.element.name).font(.headline)
                            if let d = pair.element.distanceMeters {
                                Text(formatDistance(d))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            if !pair.element.address.isEmpty {
                                Text(pair.element.address).font(.caption2).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }

            Button(action: onBack) {
                Text("気分を選び直す")
                    .frame(maxWidth: .infinity).padding()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    private func formatDistance(_ meters: CLLocationDistance) -> String {
        if meters < 1000 { return "\(Int(meters))m" }
        return String(format: "%.1fkm", meters / 1000)
    }

    private func openInMaps(_ r: Restaurant) {
        let placemark = MKPlacemark(coordinate: r.coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = r.name
        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ])
    }
}
