import Foundation
import os

/// ベンダに依存しない分析サービスの抽象。
/// 本番では Firebase / TelemetryDeck / Mixpanel 等の実装に差し替える。
protocol AnalyticsService {
    func track(_ event: AnalyticsEvent)
    func screen(_ name: String)
    func setUserProperty(_ key: String, value: String?)
}

/// 開発時のデフォルト実装：OSLog にイベントを出すだけ。
/// `Console.app` で "Meshimase/analytics" サブシステムをフィルタすると確認可能。
final class ConsoleAnalyticsService: AnalyticsService {
    private let logger = Logger(subsystem: "Meshimase", category: "analytics")

    func track(_ event: AnalyticsEvent) {
        let params = event.parameters
        if params.isEmpty {
            logger.info("event=\(event.name, privacy: .public)")
        } else {
            logger.info("event=\(event.name, privacy: .public) params=\(String(describing: params), privacy: .public)")
        }
    }

    func screen(_ name: String) {
        logger.info("screen=\(name, privacy: .public)")
    }

    func setUserProperty(_ key: String, value: String?) {
        logger.info("property \(key, privacy: .public)=\(value ?? "nil", privacy: .public)")
    }
}

/// 複数の実装を束ねるコンポジット（例：Console + Firebase を同時配信）。
final class CompositeAnalyticsService: AnalyticsService {
    private let services: [AnalyticsService]

    init(_ services: [AnalyticsService]) { self.services = services }

    func track(_ event: AnalyticsEvent) { services.forEach { $0.track(event) } }
    func screen(_ name: String) { services.forEach { $0.screen(name) } }
    func setUserProperty(_ key: String, value: String?) {
        services.forEach { $0.setUserProperty(key, value: value) }
    }
}
