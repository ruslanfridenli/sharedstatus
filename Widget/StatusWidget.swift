import WidgetKit
import SwiftUI

struct statusEntry: TimelineEntry {
    let date: Date
    let status: buddyStatus
    let lang: appLanguage
}

struct statusProvider: TimelineProvider {
    func placeholder(in context: Context) -> statusEntry {
        statusEntry(date: Date(), status: buddyStatus.all[0], lang: .de)
    }

    func getSnapshot(in context: Context, completion: @escaping (statusEntry) -> ()) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<statusEntry>) -> ()) {
        let entry = loadEntry()
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadEntry() -> statusEntry {
        let defaults = UserDefaults.standard
        let id = defaults.string(forKey: "currentStatusId") ?? "home"
        let langRaw = defaults.string(forKey: "selectedLang") ?? "de"
        let status = buddyStatus.all.first(where: { $0.id == id }) ?? buddyStatus.all[0]
        let lang = appLanguage(rawValue: langRaw) ?? .de
        return statusEntry(date: Date(), status: status, lang: lang)
    }
}

struct statusWidgetEntryView: View {
    var entry: statusProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.status.icon)
                    .font(.system(size: 36))
                    .widgetAccentable()
                Spacer()
                Text("live")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(entry.status.label(for: entry.lang))
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .widgetAccentable()

            Text(entry.lang == .de ? "gerade eben" : "just now")
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(4)
        .containerBackground(.ultraThinMaterial, for: .widget)
    }
}

@main
struct statusWidget: Widget {
    let kind: String = "statusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: statusProvider()) { entry in
            statusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("sharedstatus")
        .description("cozy status widget for your favorite person.")
        .supportedFamilies([.systemSmall])
    }
}
