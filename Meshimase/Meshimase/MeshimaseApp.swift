import SwiftUI

@main
struct MeshimaseApp: App {
    @State private var wallet = TicketWallet()
    @State private var location = LocationService()
    @State private var repository: MealRepository? = try? MealRepository.load()
    @AppStorage("meshimase.onboarding.done") private var onboardingDone = false

    /// ベンダ切替用のエントリポイント。現状は OSLog のみ。
    /// 本番では `CompositeAnalyticsService([ConsoleAnalyticsService(), FirebaseAnalyticsService()])` などに変更。
    private let analytics: AnalyticsService = ConsoleAnalyticsService()

    var body: some Scene {
        WindowGroup {
            if !onboardingDone {
                OnboardingView {
                    analytics.track(.onboardingCompleted)
                    onboardingDone = true
                }
                .onAppear { analytics.track(.onboardingStarted) }
            } else if let repository {
                HomeView(
                    wallet: wallet,
                    location: location,
                    repository: repository,
                    analytics: analytics
                )
            } else {
                VStack(spacing: 12) {
                    Text("😿").font(.system(size: 64))
                    Text("メニューデータを読み込めませんでした").font(.headline)
                }
            }
        }
    }
}
