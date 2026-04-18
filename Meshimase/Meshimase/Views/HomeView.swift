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
    let analytics: AnalyticsService
    let search = RestaurantSearch()

    init(
        wallet: TicketWallet,
        location: LocationService,
        repository: MealRepository,
        analytics: AnalyticsService
    ) {
        self.wallet = wallet
        self.location = location
        self.analytics = analytics
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
                .onAppear { analytics.screen("mood") }
            case .suggestion:
                SuggestionView(
                    meal: suggestion.current,
                    rollCount: suggestion.rollCount,
                    hasSubscription: wallet.hasActiveSubscription,
                    onReroll: handleReroll,
                    onDecide: handleDecide,
                    onGiveUp: handleGiveUp
                )
                .onAppear { analytics.screen("suggestion") }
            case .restaurants:
                if let meal = suggestion.current {
                    RestaurantListView(
                        meal: meal,
                        restaurants: restaurants,
                        isLoading: isSearching,
                        errorMessage: searchError,
                        onBack: handleGiveUp,
                        onOpenRestaurant: handleRestaurantOpened
                    )
                    .onAppear { analytics.screen("restaurants") }
                }
            }
        }
        .alert(Messages.preChargeTitle, isPresented: $showPreChargeAlert) {
            Button("やめておく", role: .cancel) {
                analytics.track(.preChargeAlertAction(action: .cancel))
            }
            Button("100円で 1回") {
                analytics.track(.preChargeAlertAction(action: .single))
                Task { await payAndReroll() }
            }
            Button("月額 480円で聞き放題") {
                analytics.track(.preChargeAlertAction(action: .subscribe))
                showPaywall = true
            }
        } message: {
            Text(Messages.preChargeMessage)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(wallet: wallet, analytics: analytics) {
                showPaywall = false
                if wallet.hasActiveSubscription {
                    roll()
                }
            }
        }
        .task {
            await wallet.loadProducts()
            location.request()
        }
        .onChange(of: location.authorizationStatus) { _, status in
            analytics.track(.locationPermissionChanged(status: String(describing: status)))
        }
    }

    // MARK: - Actions

    private func handleInitialRoll() {
        analytics.track(.moodSelected(
            volume: mood.volume,
            temperature: mood.temperature,
            genre: mood.genre,
            mealTime: mealTime
        ))
        suggestion.reset()
        roll()
        screen = .suggestion
    }

    private func handleReroll() {
        let blocked = !wallet.hasActiveSubscription && suggestion.rollCount >= 2
        analytics.track(.rerollAttempted(
            rollCount: suggestion.rollCount,
            hasSubscription: wallet.hasActiveSubscription,
            blocked: blocked
        ))
        if blocked {
            analytics.track(.preChargeAlertShown)
            showPreChargeAlert = true
            return
        }
        roll()
    }

    private func roll() {
        suggestion.roll(mealTime: mealTime, mood: mood)
        if let current = suggestion.current {
            analytics.track(.mealSuggested(
                mealID: current.id,
                rollCount: suggestion.rollCount,
                hasSubscription: wallet.hasActiveSubscription
            ))
        }
    }

    private func payAndReroll() async {
        analytics.track(.purchaseStarted(
            productID: TicketWallet.singleProductID,
            source: .preChargeDialog
        ))
        let outcome = await wallet.purchaseSingle()
        switch outcome {
        case .success:
            analytics.track(.purchaseCompleted(
                productID: TicketWallet.singleProductID,
                source: .preChargeDialog
            ))
            roll()
        case .cancelled:
            analytics.track(.purchaseCancelled(
                productID: TicketWallet.singleProductID,
                source: .preChargeDialog
            ))
        case .failed(let reason):
            analytics.track(.purchaseFailed(
                productID: TicketWallet.singleProductID,
                source: .preChargeDialog,
                reason: reason
            ))
        }
    }

    private func handleDecide() {
        guard let meal = suggestion.current else { return }
        analytics.track(.mealDecided(mealID: meal.id, totalRolls: suggestion.rollCount))
        screen = .restaurants
        Task { await loadRestaurants() }
    }

    private func handleGiveUp() {
        analytics.track(.sessionEnded(totalRolls: suggestion.rollCount, decided: screen == .restaurants))
        suggestion.reset()
        restaurants = []
        searchError = nil
        screen = .mood
    }

    private func handleRestaurantOpened(_ restaurant: Restaurant, index: Int) {
        analytics.track(.restaurantOpened(
            distanceMeters: restaurant.distanceMeters,
            index: index
        ))
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
            searchError = "位置情報が取れません。設定から許可してください。"
            analytics.track(.restaurantSearchFailed(reason: "no_location"))
        } catch RestaurantSearchError.noResults {
            searchError = "近くにお店が見つかりませんでした。"
            analytics.track(.restaurantSearchFailed(reason: "no_results"))
        } catch {
            searchError = error.localizedDescription
            analytics.track(.restaurantSearchFailed(reason: error.localizedDescription))
        }
    }
}
