import Foundation

enum MealTime: String, CaseIterable, Identifiable {
    case breakfast = "朝ごはん"
    case lunch = "ランチ"
    case dinner = "夜ごはん"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .breakfast: return "🌅"
        case .lunch: return "☀️"
        case .dinner: return "🌙"
        }
    }

    static func current(now: Date = Date(), calendar: Calendar = .current) -> MealTime {
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let totalMinutes = hour * 60 + minute
        switch totalMinutes {
        case 0..<(4 * 60):
            return .dinner
        case (4 * 60)..<(10 * 60 + 30):
            return .breakfast
        case (10 * 60 + 30)..<(15 * 60):
            return .lunch
        default:
            return .dinner
        }
    }
}
