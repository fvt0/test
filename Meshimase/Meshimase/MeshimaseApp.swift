import SwiftUI

@main
struct MeshimaseApp: App {
    @State private var wallet = TicketWallet()
    @State private var location = LocationService()
    @State private var repository: MealRepository? = try? MealRepository.load()
    @AppStorage("meshimase.onboarding.done") private var onboardingDone = false

    var body: some Scene {
        WindowGroup {
            if !onboardingDone {
                OnboardingView { onboardingDone = true }
            } else if let repository {
                HomeView(wallet: wallet, location: location, repository: repository)
            } else {
                VStack(spacing: 12) {
                    Text("😿").font(.system(size: 64))
                    Text("メニューデータを読み込めませんでした").font(.headline)
                }
            }
        }
    }
}
