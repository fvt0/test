import Foundation

enum NyashefDialog {
    static func greeting(for mealTime: MealTime) -> String {
        switch mealTime {
        case .breakfast: return "朝めしませ、何にする？"
        case .lunch: return "お昼めしませ、決めるよ。"
        case .dinner: return "今夜のごはん、悩むめしねぇ。"
        }
    }

    static func suggestionComment(rollCount: Int, meal: Meal) -> String {
        switch rollCount {
        case 1: return "これなんて、どうめしませ？"
        case 2: return "ふーん、気に入らないめしか。"
        case 3: return "優柔不断だなあ…次で決めてくれめしませ？"
        case 4: return "まだ決まらないめし？…決断料、120円めしませ。"
        default: return "もう…知らないめし！（※決断料120円）"
        }
    }

    static let confirmedComment = "よし、店まで案内するめしませ！"
    static let givenUpComment = "また次、お腹すいたら呼んでめしませ。"
    static let noCandidateComment = "その気分に合う料理、見つからないめし…条件ゆるめて？"
}
