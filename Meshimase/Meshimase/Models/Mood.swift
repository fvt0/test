import Foundation

enum Volume: String, CaseIterable, Identifiable, Codable {
    case light = "軽め"
    case heavy = "がっつり"
    case any = "おまかせ"
    var id: String { rawValue }
}

enum Temperature: String, CaseIterable, Identifiable, Codable {
    case hot = "温かい"
    case cold = "冷たい"
    case any = "おまかせ"
    var id: String { rawValue }
}

enum Genre: String, CaseIterable, Identifiable, Codable {
    case japanese = "和"
    case western = "洋"
    case chinese = "中"
    case asian = "アジア"
    case any = "おまかせ"
    var id: String { rawValue }
}

struct Mood: Equatable {
    var volume: Volume = .any
    var temperature: Temperature = .any
    var genre: Genre = .any
}
