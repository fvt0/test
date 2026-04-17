import Foundation

struct Meal: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let volume: Volume
    let temperature: Temperature
    let genre: Genre
    let mealTimes: [MealTimeTag]
    let searchKeyword: String

    enum MealTimeTag: String, Codable {
        case breakfast
        case lunch
        case dinner
    }
}

extension Meal.MealTimeTag {
    static func from(_ mealTime: MealTime) -> Meal.MealTimeTag {
        switch mealTime {
        case .breakfast: return .breakfast
        case .lunch: return .lunch
        case .dinner: return .dinner
        }
    }
}
