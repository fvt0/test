import Foundation
import Observation
import StoreKit

@Observable
final class TicketWallet {
    static let singleProductID = "com.meshimase.ticket.single"
    static let subscriptionProductID = "com.meshimase.subscription.monthly"

    private(set) var singleProduct: Product?
    private(set) var subscriptionProduct: Product?
    private(set) var hasActiveSubscription: Bool = false
    private(set) var purchaseError: String?

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await verification in Transaction.updates {
                if case .verified(let tx) = verification {
                    await self?.refreshSubscriptionStatus()
                    await tx.finish()
                }
            }
        }
    }

    deinit { updatesTask?.cancel() }

    func loadProducts() async {
        do {
            let products = try await Product.products(for: [
                Self.singleProductID,
                Self.subscriptionProductID
            ])
            singleProduct = products.first { $0.id == Self.singleProductID }
            subscriptionProduct = products.first { $0.id == Self.subscriptionProductID }
            await refreshSubscriptionStatus()
        } catch {
            purchaseError = error.localizedDescription
        }
    }

    func refreshSubscriptionStatus() async {
        var active = false
        for await verification in Transaction.currentEntitlements {
            if case .verified(let tx) = verification,
               tx.productID == Self.subscriptionProductID,
               tx.revocationDate == nil {
                if let expires = tx.expirationDate, expires > .now {
                    active = true
                }
            }
        }
        hasActiveSubscription = active
    }

    enum PurchaseOutcome {
        case success
        case cancelled
        case failed(String)
    }

    func purchaseSingle() async -> PurchaseOutcome {
        await purchase(product: singleProduct)
    }

    func purchaseSubscription() async -> PurchaseOutcome {
        await purchase(product: subscriptionProduct)
    }

    private func purchase(product: Product?) async -> PurchaseOutcome {
        guard let product else { return .failed("商品読み込み中です") }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let tx) = verification {
                    await tx.finish()
                    await refreshSubscriptionStatus()
                    return .success
                }
                return .failed("購入の検証に失敗しました")
            case .userCancelled:
                return .cancelled
            case .pending:
                return .failed("承認待ちです")
            @unknown default:
                return .failed("不明な結果です")
            }
        } catch {
            return .failed(error.localizedDescription)
        }
    }
}
