import Foundation
import Observation

@Observable
final class SuggestionEngine {
    private let repository: MealRepository
    private(set) var current: Meal?
    private(set) var rollCount: Int = 0
    private var recentIDs: [String] = []

    init(repository: MealRepository) {
        self.repository = repository
    }

    func roll(mealTime: MealTime, mood: Mood) {
        let candidates = repository.filtered(mealTime: mealTime, mood: mood)
        guard !candidates.isEmpty else {
            current = nil
            return
        }
        let pool = candidates.filter { !recentIDs.contains($0.id) }
        let source = pool.isEmpty ? candidates : pool
        let next = source.randomElement()
        if let next {
            recentIDs.append(next.id)
            if recentIDs.count > 3 { recentIDs.removeFirst() }
        }
        current = next
        rollCount += 1
    }

    func reset() {
        current = nil
        rollCount = 0
        recentIDs.removeAll()
    }

    var shouldNudge: Bool { rollCount >= 3 }
}
