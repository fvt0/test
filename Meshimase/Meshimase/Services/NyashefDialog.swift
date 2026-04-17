import Foundation

enum NyashefDialog {
    static func greeting(for mealTime: MealTime) -> String {
        switch mealTime {
        case .breakfast: return "朝めしませ、何にする？"
        case .lunch: return "お昼めしませ、決めるよ。"
        case .dinner: return "今夜のごはん、悩むめしねぇ。"
        }
    }

    /// rollCount はロール直後の累計回数（1始まり）
    static func suggestionComment(rollCount: Int) -> String {
        switch rollCount {
        case 1: return "これなんて、どうめしませ？"
        case 2: return "ふーん、気に入らないめしか。"
        case 3: return "優柔不断だなあ…お代いただくめしませ。"
        default: return "まだ迷うめし？…ありがたくお代もらうめし。"
        }
    }

    static let preChargeTitle = "次からは決断料めしませ"
    static let preChargeMessage = "3回目からは1回100円、または月額480円で聞き放題めしませ。どうする？"
    static let confirmedComment = "よし、店まで案内するめしませ！"
    static let givenUpComment = "また次、お腹すいたら呼んでめしませ。"
    static let noCandidateComment = "その気分に合う料理、見つからないめし…条件ゆるめて？"
    static let subscriptionBadge = "♾ 聞き放題中めし"
}
