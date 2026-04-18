import Foundation

/// アプリ内で発行する分析イベントの型安全な定義。
/// 新規イベントを追加する場合は、このenumにケースを追加し、`name`と`parameters`を更新する。
enum AnalyticsEvent {
    case onboardingStarted
    case onboardingCompleted

    case moodSelected(volume: Volume, temperature: Temperature, genre: Genre, mealTime: MealTime)
    case mealSuggested(mealID: String, rollCount: Int, hasSubscription: Bool)
    case rerollAttempted(rollCount: Int, hasSubscription: Bool, blocked: Bool)

    case preChargeAlertShown
    case preChargeAlertAction(action: PreChargeAction)

    case purchaseStarted(productID: String, source: PurchaseSource)
    case purchaseCompleted(productID: String, source: PurchaseSource)
    case purchaseFailed(productID: String, source: PurchaseSource, reason: String)
    case purchaseCancelled(productID: String, source: PurchaseSource)

    case mealDecided(mealID: String, totalRolls: Int)
    case restaurantOpened(distanceMeters: Double?, index: Int)
    case sessionEnded(totalRolls: Int, decided: Bool)

    case locationPermissionChanged(status: String)
    case restaurantSearchFailed(reason: String)

    enum PreChargeAction: String { case single, subscribe, cancel }
    enum PurchaseSource: String { case preChargeDialog = "pre_charge_dialog", paywall }

    var name: String {
        switch self {
        case .onboardingStarted: return "onboarding_started"
        case .onboardingCompleted: return "onboarding_completed"
        case .moodSelected: return "mood_selected"
        case .mealSuggested: return "meal_suggested"
        case .rerollAttempted: return "reroll_attempted"
        case .preChargeAlertShown: return "pre_charge_alert_shown"
        case .preChargeAlertAction: return "pre_charge_alert_action"
        case .purchaseStarted: return "purchase_started"
        case .purchaseCompleted: return "purchase_completed"
        case .purchaseFailed: return "purchase_failed"
        case .purchaseCancelled: return "purchase_cancelled"
        case .mealDecided: return "meal_decided"
        case .restaurantOpened: return "restaurant_opened"
        case .sessionEnded: return "session_ended"
        case .locationPermissionChanged: return "location_permission_changed"
        case .restaurantSearchFailed: return "restaurant_search_failed"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .onboardingStarted, .onboardingCompleted, .preChargeAlertShown:
            return [:]
        case let .moodSelected(volume, temperature, genre, mealTime):
            return [
                "volume": volume.rawValue,
                "temperature": temperature.rawValue,
                "genre": genre.rawValue,
                "meal_time": mealTime.rawValue
            ]
        case let .mealSuggested(mealID, rollCount, hasSubscription):
            return [
                "meal_id": mealID,
                "roll_count": rollCount,
                "has_subscription": hasSubscription
            ]
        case let .rerollAttempted(rollCount, hasSubscription, blocked):
            return [
                "roll_count": rollCount,
                "has_subscription": hasSubscription,
                "blocked_by_paywall": blocked
            ]
        case let .preChargeAlertAction(action):
            return ["action": action.rawValue]
        case let .purchaseStarted(productID, source),
             let .purchaseCompleted(productID, source),
             let .purchaseCancelled(productID, source):
            return ["product_id": productID, "source": source.rawValue]
        case let .purchaseFailed(productID, source, reason):
            return ["product_id": productID, "source": source.rawValue, "reason": reason]
        case let .mealDecided(mealID, totalRolls):
            return ["meal_id": mealID, "total_rolls": totalRolls]
        case let .restaurantOpened(distanceMeters, index):
            var p: [String: Any] = ["index": index]
            if let d = distanceMeters { p["distance_meters"] = Int(d) }
            return p
        case let .sessionEnded(totalRolls, decided):
            return ["total_rolls": totalRolls, "decided": decided]
        case let .locationPermissionChanged(status):
            return ["status": status]
        case let .restaurantSearchFailed(reason):
            return ["reason": reason]
        }
    }
}
