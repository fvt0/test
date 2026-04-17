import Foundation

enum MealRepositoryError: Error {
    case resourceNotFound
    case decodingFailed(Error)
}

struct MealRepository {
    let meals: [Meal]

    static func load(bundle: Bundle = .main) throws -> MealRepository {
        guard let url = bundle.url(forResource: "meals", withExtension: "json") else {
            throw MealRepositoryError.resourceNotFound
        }
        let data = try Data(contentsOf: url)
        do {
            let meals = try JSONDecoder().decode([Meal].self, from: data)
            return MealRepository(meals: meals)
        } catch {
            throw MealRepositoryError.decodingFailed(error)
        }
    }

    func filtered(mealTime: MealTime, mood: Mood) -> [Meal] {
        let tag = Meal.MealTimeTag.from(mealTime)
        return meals.filter { meal in
            guard meal.mealTimes.contains(tag) else { return false }
            if mood.volume != .any, meal.volume != mood.volume { return false }
            if mood.temperature != .any, meal.temperature != mood.temperature { return false }
            if mood.genre != .any, meal.genre != mood.genre { return false }
            return true
        }
    }
}
