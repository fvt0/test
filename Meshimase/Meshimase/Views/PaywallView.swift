import SwiftUI

struct PaywallView: View {
    let wallet: TicketWallet
    let analytics: AnalyticsService
    let onDone: () -> Void
    @State private var isPurchasing = false
    @State private var errorText: String?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "infinity.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.orange)
            Text(Messages.paywallTitle).font(.title2).bold()
            Text(Messages.paywallBody)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            if let product = wallet.subscriptionProduct {
                Text(product.displayPrice + " / 月")
                    .font(.title3).bold()
            }

            if let errorText {
                Text(errorText).font(.caption).foregroundStyle(.red)
            }

            Button(action: purchase) {
                Text(isPurchasing ? "処理中…" : "加入する")
                    .font(.headline)
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(isPurchasing || wallet.subscriptionProduct == nil)

            Button("閉じる", role: .cancel, action: onDone)
        }
        .padding()
    }

    private func purchase() {
        Task {
            isPurchasing = true
            defer { isPurchasing = false }
            analytics.track(.purchaseStarted(
                productID: TicketWallet.subscriptionProductID,
                source: .paywall
            ))
            let outcome = await wallet.purchaseSubscription()
            switch outcome {
            case .success:
                analytics.track(.purchaseCompleted(
                    productID: TicketWallet.subscriptionProductID,
                    source: .paywall
                ))
                onDone()
            case .cancelled:
                analytics.track(.purchaseCancelled(
                    productID: TicketWallet.subscriptionProductID,
                    source: .paywall
                ))
            case .failed(let msg):
                analytics.track(.purchaseFailed(
                    productID: TicketWallet.subscriptionProductID,
                    source: .paywall,
                    reason: msg
                ))
                errorText = msg
            }
        }
    }
}
