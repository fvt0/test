import SwiftUI

struct MessageBanner: View {
    let text: String
    var emphasize: Bool = false

    var body: some View {
        Text(text)
            .font(emphasize ? .headline : .subheadline)
            .foregroundStyle(emphasize ? Color.orange : .primary)
            .padding(.horizontal, 14).padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .animation(.easeInOut, value: text)
    }
}
