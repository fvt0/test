import SwiftUI

struct SuggestionView: View {
    let meal: Meal?
    let rollCount: Int
    let hasSubscription: Bool
    let onReroll: () -> Void
    let onDecide: () -> Void
    let onGiveUp: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            NyashefBubble(
                message: meal == nil
                    ? NyashefDialog.noCandidateComment
                    : NyashefDialog.suggestionComment(rollCount: rollCount),
                emphasize: rollCount >= 3
            )

            if let meal {
                mealCard(meal)
            }

            if hasSubscription {
                Label(NyashefDialog.subscriptionBadge, systemImage: "infinity")
                    .font(.caption).foregroundStyle(.orange)
            }

            HStack(spacing: 12) {
                Button(role: .cancel, action: onGiveUp) {
                    Text("やめる").frame(maxWidth: .infinity).padding()
                }
                .buttonStyle(.bordered)

                Button(action: onReroll) {
                    VStack(spacing: 2) {
                        Text("別のを見る")
                        if rollCount >= 2 && !hasSubscription {
                            Text(rollCount >= 2 ? "次は100円" : "")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity).padding()
                }
                .buttonStyle(.bordered)
            }
            .disabled(meal == nil)

            Button(action: onDecide) {
                Text("これにする！")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(meal == nil)
        }
        .padding()
    }

    private func mealCard(_ meal: Meal) -> some View {
        VStack(spacing: 8) {
            Text(meal.emoji).font(.system(size: 96))
            Text(meal.name).font(.title).bold()
            HStack(spacing: 8) {
                tag(meal.genre.rawValue)
                tag(meal.volume.rawValue)
                tag(meal.temperature.rawValue)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10).padding(.vertical, 4)
            .background(Capsule().fill(Color(.tertiarySystemBackground)))
    }
}
