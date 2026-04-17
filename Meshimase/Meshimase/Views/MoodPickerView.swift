import SwiftUI

struct MoodPickerView: View {
    @Binding var mood: Mood
    let mealTime: MealTime
    var onMealTimeChange: (MealTime) -> Void
    var onRoll: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("\(mealTime.emoji) 今は\(mealTime.rawValue)タイム")
                    .font(.headline)
                Spacer()
                Menu("変更") {
                    ForEach(MealTime.allCases) { t in
                        Button("\(t.emoji) \(t.rawValue)") { onMealTimeChange(t) }
                    }
                }
            }

            NyashefBubble(message: NyashefDialog.greeting(for: mealTime))

            axisPicker(title: "ボリューム", selection: $mood.volume, options: Volume.allCases)
            axisPicker(title: "温度", selection: $mood.temperature, options: Temperature.allCases)
            axisPicker(title: "ジャンル", selection: $mood.genre, options: Genre.allCases)

            Button(action: onRoll) {
                Text("ごはんを決める")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding()
    }

    private func axisPicker<T: Hashable & Identifiable & RawRepresentable>(
        title: String,
        selection: Binding<T>,
        options: [T]
    ) -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline).foregroundStyle(.secondary)
            Picker(title, selection: selection) {
                ForEach(options) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
