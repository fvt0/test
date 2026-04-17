import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let body: String
}

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var index = 0

    private let pages: [OnboardingPage] = [
        .init(emoji: "🕒",
              title: "時間に合わせて、ごはん提案",
              body: "朝・昼・夜、アプリを開いた時間に合わせてニャシェフが1品選んでくれるめしませ。"),
        .init(emoji: "🎛",
              title: "気分を3つ選ぶだけ",
              body: "ボリューム・温度・ジャンルをゆるっと選べば、気分に合う料理をガチャで提案するめし。"),
        .init(emoji: "🗺",
              title: "決まったら、近くのお店へ",
              body: "「これにする」を押すと、周辺の候補店を一覧表示。タップで地図アプリに連携めし。"),
        .init(emoji: "💴",
              title: "3回以上迷うと、決断料",
              body: "2回までは無料。3回目からは1回100円、または月額480円で聞き放題めしませ。")
    ]

    var body: some View {
        VStack(spacing: 24) {
            TabView(selection: $index) {
                ForEach(Array(pages.enumerated()), id: \.offset) { pair in
                    pageView(pair.element).tag(pair.offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button(action: next) {
                Text(index == pages.count - 1 ? "はじめる" : "次へ")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
    }

    private func pageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Text(page.emoji).font(.system(size: 88))
            Text(page.title).font(.title2).bold()
            Text(page.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
            Spacer()
        }
    }

    private func next() {
        if index < pages.count - 1 { index += 1 } else { onFinish() }
    }
}
