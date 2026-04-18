import SwiftUI

enum Screen {
    case mood
    case suggestion
    case restaurants
}

struct HomeView: View {
    @State private var screen: Screen = .mood
    @State private var mealTime: MealTime = .current()
    @State private var mood = Mood()
    @State private var showPreChargeAlert = false
    @State private var showPaywall = false
    @State private var restaurants: [Restaurant] = []
    @State private var isSearching = false
    @State private var searchError: String?

    @State private var suggestion: SuggestionEngine
    let wallet: TicketWallet
    let location: LocationService
    let search = RestaurantSearch()

    init(wallet: TicketWallet, location: LocationService, repository: MealRepository) {
        self.wallet = wallet
        self.location = location
        _suggestion = State(initialValue: SuggestionEngine(repository: repository))
    }

    var body: some View {
        ScrollView {
            switch screen {
            case .mood:
                MoodPickerView(
                    mood: $mood,
                    mealTime: mealTime,
                    onMealTimeChange: { mealTime = $0 },
                    onRoll: handleInitialRoll
                )
            case .suggestion:
                SuggestionView(
                    meal: suggestion.current,
                    rollCount: suggestion.rollCount,
                    hasSubscription: wallet.hasActiveSubscription,
                    onReroll: handleReroll,
                    onDecide: handleDecide,
                    onGiveUp: handleGiveUp
                )
            case .restaurants:
                if let meal = suggestion.current {
                    RestaurantListView(
                        meal: meal,
                        restaurants: restaurants,
                        isLoading: isSearching,
                        errorMessage: searchError,
                        onBack: handleGiveUp
                    )
                }
            }
        }
        .alert(Messages.preChargeTitle, isPresented: $showPreChargeAlert) {
            Button("やめておく", role: .cancel) {}
            Button("100円で 1回") { Task { await payAndReroll() } }
            Button("月額 480円で聞き放題") { showPaywall = true }
        } message: {
            Text(Messages.preChargeMessage)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(wallet: wallet) {
                showPaywall = false
                if wallet.hasActiveSubscription {
                    suggestion.roll(mealTime: mealTime, mood: mood)
                }
            }
        }
        .task {
            await wallet.loadProducts()
            location.request()
        }
    }

    // MARK: - Actions

    private func handleInitialRoll() {
        suggestion.reset()
        suggestion.roll(mealTime: mealTime, mood: mood)
        screen = .suggestion
    }

    private func handleReroll() {
        // ロール後の次回（3回目以降）が課金対象。rollCount == 2 の直後に再ロールで3回目に突入。
        if !wallet.hasActiveSubscription && suggestion.rollCount >= 2 {
            showPreChargeAlert = true
            return
        }
        suggestion.roll(mealTime: mealTime, mood: mood)
    }

    private func payAndReroll() async {
        let outcome = await wallet.purchaseSingle()
        if case .success = outcome {
            suggestion.roll(mealTime: mealTime, mood: mood)
        }
    }

    private func handleDecide() {
        guard suggestion.current != nil else { return }
        screen = .restaurants
        Task { await loadRestaurants() }
    }

    private func handleGiveUp() {
        suggestion.reset()
        restaurants = []
        searchError = nil
        screen = .mood
    }

    private func loadRestaurants() async {
        guard let meal = suggestion.current else { return }
        isSearching = true
        searchError = nil
        defer { isSearching = false }
        do {
            restaurants = try await search.search(
                keyword: meal.searchKeyword,
                around: location.currentLocation
            )
        } catch RestaurantSearchError.noLocation {
            searchError = "位置情報が取れないめし…設定から許可してね。"
        } catch RestaurantSearchError.noResults {
            searchError = "近くにお店が見つからないめし。"
        } catch {
            searchError = error.localizedDescription
        }
    }
}
