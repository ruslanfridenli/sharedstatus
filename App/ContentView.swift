import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("selectedLang") private var langRaw: String = "de"
    @AppStorage("currentStatusId") private var currentStatusId: String = "home"

    private var lang: appLanguage {
        appLanguage(rawValue: langRaw) ?? .de
    }

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 24) {
            // header
            HStack {
                Text("sharedstatus")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                Spacer()
                Button(action: toggleLanguage) {
                    Text(lang == .de ? "de / en" : "en / de")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)

            // prompt
            Text(lang == .de ? "wie ist dein vibe gerade?" : "what's your vibe right now?")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            // status grid
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(buddyStatus.all) { item in
                    let isSelected = item.id == currentStatusId
                    Button {
                        selectStatus(item)
                    } label: {
                        VStack(spacing: 10) {
                            Text(item.icon)
                                .font(.system(size: 34))
                            Text(item.label(for: lang))
                                .font(.system(.footnote, design: .rounded, weight: .medium))
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(isSelected ? Color.primary.opacity(0.08) : Color.secondary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(isSelected ? Color.primary.opacity(0.3) : Color.clear, lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 20)
    }

    private func toggleLanguage() {
        langRaw = (lang == .de) ? "en" : "de"
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func selectStatus(_ status: buddyStatus) {
        currentStatusId = status.id
        WidgetCenter.shared.reloadAllTimelines()
    }
}
