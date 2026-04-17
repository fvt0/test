import SwiftUI

struct NyashefBubble: View {
    let message: String
    var emphasize: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("🐱‍🍳")
                .font(.system(size: 44))
                .padding(8)
                .background(Circle().fill(Color(.systemBackground)).shadow(radius: 2))
            Text(message)
                .font(emphasize ? .headline : .body)
                .foregroundStyle(emphasize ? Color.orange : .primary)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
            Spacer(minLength: 0)
        }
    }
}
