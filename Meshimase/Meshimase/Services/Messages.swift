import Foundation

enum Messages {
    static func greeting(for mealTime: MealTime) -> String {
        switch mealTime {
        case .breakfast: return "朝ごはん、何にする？"
        case .lunch: return "お昼ごはん、決めよう。"
        case .dinner: return "今夜のごはん、何食べる？"
        }
    }

    /// rollCount はロール直後の累計回数（1始まり）
    static func suggestionComment(rollCount: Int) -> String {
        switch rollCount {
        case 1: return "今日はこれ、どう？"
        case 2: return "違った？次いってみよう。"
        case 3: return "優柔不断…ここから決断料。"
        default: return "まだ迷う？ちゃんと決断料もらうよ。"
        }
    }

    static let preChargeTitle = "ここから決断料"
    static let preChargeMessage = "3回目以降は1回 100円、または月額 480円で回し放題。"
    static let confirmedComment = "近くのお店はこちら。"
    static let noCandidateComment = "ぴったりの料理が見つからない…条件をゆるめてみて。"
    static let subscriptionBadge = "♾ 聞き放題プラン"
    static let paywallTitle = "悩むなら、聞き放題に。"
    static let paywallBody = "月額 480円で決断料なし。いつでも解約できます。"
}
