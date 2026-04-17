import Foundation
import Observation
import StoreKit

@Observable
final class TicketWallet {
    static let productID = "com.meshimase.ticket.single"
    private let ticketKey = "meshimase.ticket.count"
    private let firstLaunchKey = "meshimase.first_launch_bonus_given"

    private(set) var count: Int
    private(set) var product: Product?
    private(set) var purchaseError: String?

    init(defaults: UserDefaults = .standard) {
        let stored = defaults.integer(forKey: ticketKey)
        if defaults.bool(forKey: firstLaunchKey) == false {
            defaults.set(stored + 1, forKey: ticketKey)
            defaults.set(true, forKey: firstLaunchKey)
            self.count = stored + 1
        } else {
            self.count = stored
        }
    }

    func spend() -> Bool {
        guard count > 0 else { return false }
        count -= 1
        persist()
        return true
    }

    func grant(_ n: Int = 1) {
        count += n
        persist()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
        } catch {
            purchaseError = error.localizedDescription
        }
    }

    func purchase() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    grant(1)
                    await transaction.finish()
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            purchaseError = error.localizedDescription
        }
    }

    private func persist() {
        UserDefaults.standard.set(count, forKey: ticketKey)
    }
}
