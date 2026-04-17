import SwiftUI

struct PaywallView: View {
    let wallet: TicketWallet
    let onDone: () -> Void
    @State private var isPurchasing = false
    @State private var errorText: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("🐱‍🍳").font(.system(size: 72))
            Text("悩むなら、聞き放題めしませ").font(.title2).bold()
            Text("月額480円で、決断料なしでガチャ回し放題。いつでも解約できるめし。")
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
                Text(isPurchasing ? "処理中めし…" : "加入する")
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
            let outcome = await wallet.purchaseSubscription()
            switch outcome {
            case .success:
                onDone()
            case .cancelled:
                break
            case .failed(let msg):
                errorText = msg
            }
        }
    }
}
